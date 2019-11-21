pragma solidity ^0.5.11;

import "./lib/SafeMath.sol";
import "./lib/IERC20.sol";
import "./_curveIntegrals/v1/ICurveFunctions.sol";
import "./lib/ERC20Detailed.sol";
import "./TrojanPool.sol";

contract TrojanToken is ERC20Detailed {

    using SafeMath for uint256;
    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowed;

    event TrojanRedistribution(address from, uint amount);
    event Mint(address to, uint amount);
    event Sell(address from, uint amount);
    event DaoTax(uint256 amount);

    //uint256 public constant MAX_SUPPLY = 400000000 * 10 ** 18; // 40000 ETH of Sparkle
    //uint256 public constant PERCENT = 100; // 100%
    uint256 public constant MINT_TAX = 2; // 2%
    uint256 public constant BURN_TAX = 3; // 3%
    uint256 public constant TRANSFER_TAX = 1; // 1%
    //uint256 public constant COST_PER_TOKEN = 1e14; // 1 Sparkle = .0001 ETH

    uint256 private _tobinsCollected;
    uint256 private _totalSupply;
    mapping (address => uint256) private _tobinsClaimed; // Internal accounting

    // Address of curve function
    ICurveFunctions internal curveLibrary_;
    // Underlying collateral token
    IERC20 internal collateralToken_;
    TrojanPool trojanPool;

    constructor(address _curveLibrary, address _collateralToken) public ERC20Detailed("TrojanDAO", "TROJ", 18) {
        curveLibrary_ = ICurveFunctions(_curveLibrary);
        collateralToken_ = IERC20(_collateralToken);

        uint256 bootstrap = 1000 * 10 ** 18;
        // TODO: TESTING
        _balances[msg.sender] = bootstrap;
        _totalSupply = bootstrap;
    }

    // TODO: this had a circular dependency, fix this better
    function setTrojanPool(address _trojanPool) public {
        trojanPool = TrojanPool(_trojanPool);
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function tobinsCollected() public view returns (uint256) {
        return _tobinsCollected;
    }

    function balanceOf(address owner) public view returns (uint256) {
        if (_totalSupply == 0) return 0;

        uint256 unclaimed = _tobinsCollected.sub(_tobinsClaimed[owner]);
        uint256 floatingSupply = _totalSupply.sub(_tobinsCollected);
        uint256 redistribution = _balances[owner].mul(unclaimed).div(floatingSupply);

        return _balances[owner].add(redistribution);
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowed[owner][spender];
    }

    function transfer(address to, uint256 value) public returns (bool) {
        require(to != address(0), "Bad address");

        uint256 taxAmount = value.mul(TRANSFER_TAX).div(PERCENT);

        _balances[msg.sender] = balanceOf(msg.sender).sub(value).sub(taxAmount);
        _balances[to] = balanceOf(to).add(value);

        _tobinsClaimed[msg.sender] = _tobinsCollected;
        _tobinsClaimed[to] = _tobinsCollected;
        _tobinsCollected = _tobinsCollected.add(taxAmount);

        emit Transfer(msg.sender, to, value);
        emit TrojanRedistribution(msg.sender, taxAmount);

        return true;
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        require(value <= _allowed[from][msg.sender], "Not enough allowance");
        require(to != address(0), "Bad address");

        uint256 taxAmount = value.mul(TRANSFER_TAX).div(PERCENT);

        _balances[from] = balanceOf(from).sub(value).sub(taxAmount);
        _balances[to] = balanceOf(to).add(value);

        _tobinsClaimed[from] = _tobinsCollected;
        _tobinsClaimed[to] = _tobinsCollected;
        _tobinsCollected = _tobinsCollected.add(taxAmount);

        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);

        emit Transfer(from, to, value);
        emit TrojanRedistribution(from, taxAmount);

        return true;
    }

    function approve(address spender, uint256 value) public returns (bool) {
        require(spender != address(0), "Bad address");
        _allowed[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        require(spender != address(0), "Bad address");
        _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        require(spender != address(0), "Bad address");
        _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
        return true;
    }

    function () external payable {
        mintTrojan();
    }

    function mintTrojan() public payable returns (bool) {
        //uint256 amount = msg.value.mul(10 ** 18).div(COST_PER_TOKEN);
        //require(_totalSupply.add(amount) <= MAX_SUPPLY, "Max supply reached");

        uint256 taxAmount = amount.mul(MINT_TAX).div(PERCENT);
        uint256 buyerAmount = amount.sub(taxAmount);

        _balances[msg.sender] = balanceOf(msg.sender).add(buyerAmount);

        // need to add to this contract balance so that it can deposit into the dao
        _balances[address(this)] = balanceOf(address(this)).add(taxAmount);

        _totalSupply = _totalSupply.add(amount);

        _tobinsClaimed[msg.sender] = _tobinsCollected;
        _tobinsCollected = _tobinsCollected.add(taxAmount);

        // deposit tax to trojan pool
        daoTax(taxAmount);

        emit Mint(msg.sender, buyerAmount);
        emit TrojanRedistribution(msg.sender, taxAmount);

        return true;
    }

    function sellTrojan(uint256 amount) public returns (bool) {
        require(amount > 0 && balanceOf(msg.sender) >= amount, "Balance exceeded");

        uint256 reward = amount.mul(COST_PER_TOKEN).div(10 ** 18);

        uint256 taxAmount = reward.mul(BURN_TAX).div(PERCENT);
        uint256 sellerAmount = reward.sub(taxAmount);

        _balances[msg.sender] = balanceOf(msg.sender).sub(amount);
        _tobinsClaimed[msg.sender] = _tobinsCollected;

        // need to add to this contract balance so that it can deposit into the dao
        _balances[address(this)] = balanceOf(address(this)).add(taxAmount);

        _totalSupply = _totalSupply.sub(amount);

        // deposit tax to trojan pool
        daoTax(taxAmount);

        msg.sender.transfer(sellerAmount);

        emit Sell(msg.sender, amount);

        return true;
    }

    function daoTax(uint256 amount) internal {
        this.approve(address(trojanPool), amount);
        trojanPool.deposit(amount);
        emit DaoTax(amount);
    }

    /**
      * @notice This function returns the amount of tokens one can receive for a
      *         specified amount of collateral token.
      * @param  _collateralTokenOffered : Amount of reserve token offered for
      *         purchase.
      * @return uint256 : The amount of tokens once can purchase with the
      *         specified collateral.
      */
    function collateralToTokenBuying(
        uint256 _collateralTokenOffered
    )
        external
        view
        returns(uint256)
    {
        // Works out the inverse curve of the pool with the fee removed amount
        return _inverseCurveIntegral(
            _curveIntegral(totalSupply_).add(_collateralTokenOffered)
        ).sub(totalSupply_);
    }

    /**
      * @notice This function returns the amount of tokens needed to be burnt to
      *         withdraw a specified amount of reserve token.
      * @param  _collateralTokenNeeded : Amount of dai to be withdraw.
      */
    function collateralToTokenSelling(
        uint256 _collateralTokenNeeded
    )
        external
        view
        returns(uint256)
    {
        return uint256(
            totalSupply_.sub(
                _inverseCurveIntegral(
                    _curveIntegral(totalSupply_).sub(_collateralTokenNeeded)
                )
            )
        );
    }

    /**
	  * @dev	Returns the required collateral amount for a volume of bonding
	  *			curve tokens
	  * @param	_numTokens: The number of tokens to calculate the price of
      * @return uint256 : The required collateral amount for a volume of bonding
      *         curve tokens.
      */
    function priceToMint(uint256 _numTokens) public view returns(uint256) {
        // Gets the balance of the market
        uint256 balance = collateralToken_.balanceOf(address(this));
        // Performs the curve intergral with the relavant vaules
        uint256 collateral = _curveIntegral(
                _totalSupply.add(_numTokens)
            ).sub(balance);
        return collateral;
    }

    /**
	  * @dev	Returns the required collateral amount for a volume of bonding
	  *			curve tokens
	  * @param	_numTokens: The number of tokens to work out the collateral
	  *			vaule of
      * @return uint256: The required collateral amount for a volume of bonding
      *         curve tokens
      */
    function rewardForBurn(uint256 _numTokens) public view returns(uint256) {
        // Gets the curent balance of the market
        uint256 poolBalanceFetched = collateralToken_.balanceOf(address(this));
        // Returns the pool balance minus the curve intergral of the removed
        // tokens
        return poolBalanceFetched.sub(
            _curveIntegral(_totalSupply.sub(_numTokens))
        );
    }

     /**
      * @dev    Calculate the integral from 0 to x tokens supply. Calls the
      *         curve integral function on the math library.
      * @param  _x : The number of tokens supply to integrate to.
      * @return he total supply in tokens, not wei.
      */
    function _curveIntegral(uint256 _x) internal view returns (uint256) {
        return curveLibrary_.curveIntegral(_x);
    }

    /**
      * @dev    Inverse integral to convert the incoming colateral value to
      *         token volume.
      * @param  _x : The volume to identify the root off
      */
    function _inverseCurveIntegral(uint256 _x) internal view returns(uint256) {
        return curveLibrary_.inverseCurveIntegral(_x);
    }

}