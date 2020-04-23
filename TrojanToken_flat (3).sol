pragma solidity ^0.5.11;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */

library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     *
     * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
     * @dev Get it via `npm install @openzeppelin/contracts@next`.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
     * @dev Get it via `npm install @openzeppelin/contracts@next`.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     *
     * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
     * @dev Get it via `npm install @openzeppelin/contracts@next`.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

/**
 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
 * the optional functions; to access them see {ERC20Detailed}.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

/**
  * @author @veronicaLC (Veronica Coutts) & @BenSchZA (Ben Scholtz)
  * @title  The interface for the curve functions.
  */
interface ICurveFunctions {
    /**
      * @dev    Calculates the definite integral of the curve
      * @param  _x : Token value for upper limit of definite integral
      */
    function curveIntegral(uint256 _x) external pure returns(uint256);

    /**
      * @dev    Calculates the definite inverse integral of the curve
      * @param  _x : collateral value for upper limit of definite integral
      */
    function inverseCurveIntegral(uint256 _x) external pure returns(uint256);
}







/**
 * @dev Optional functions from the ERC20 standard.
 */



contract ERC20Detailed is IERC20 {
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    /**
     * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
     * these values are immutable: they can only be set once during
     * construction.
     */
    constructor (string memory name, string memory symbol, uint8 decimals) public {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei.
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view returns (uint8) {
        return _decimals;
    }
}


// Pool.sol
// - mints a pool share when someone donates tokens
// - syncs with Moloch proposal queue to mint shares for grantees
// - allows donors to withdraw tokens at any time



// Goals
// - Defensibility -> Kick out malicious members via forceRagequit
// - Separation of Wealth and Power -> voting / loot tokens - grant pool can't be claimed (controlled by separate contract?)
// - batch proposals -> 1 month between proposal batches, 2 week voting period, 2 week grace period
// - better spam protection -> exponential increase in deposit for same member / option to claim deposit
// - replacing members?
//   - hasn't been discussed
// - accountability to stakeholders
//   - some kind of siganlling








/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
     * account.
     */
    constructor () internal {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
    }

    /**
     * @return the address of the owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(isOwner());
        _;
    }

    /**
     * @return true if `msg.sender` is the owner of the contract.
     */
    function isOwner() public view returns (bool) {
        return msg.sender == _owner;
    }

    /**
     * @dev Allows the current owner to relinquish control of the contract.
     * @notice Renouncing to ownership will leave the contract without an owner.
     * It will not be possible to call the functions with the `onlyOwner`
     * modifier anymore.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0));
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}



contract GuildBank is Ownable {
    using SafeMath for uint256;

    IERC20 public approvedToken; // approved token contract reference

    event Withdrawal(address indexed receiver, uint256 amount);

    constructor(address approvedTokenAddress) public {
        approvedToken = IERC20(approvedTokenAddress);
    }

    function withdraw(address receiver, uint256 shares, uint256 totalShares) public onlyOwner returns (bool) {
        uint256 amount = approvedToken.balanceOf(address(this)).mul(shares).div(totalShares);
        emit Withdrawal(receiver, amount);
        return approvedToken.transfer(receiver, amount);
    }
}


contract TrojanDao {
    using SafeMath for uint256;

    /***************
    GLOBAL CONSTANTS
    ***************/
  uint256 public periodDuration; // default = 17280 = 4.8 hours in seconds (5 periods per day)
    uint256 public votingPeriodLength; // default = 35 periods (7 days)
    uint256 public gracePeriodLength; // default = 35 periods (7 days)
    uint256 public abortWindow; // default = 5 periods (1 day)
    uint256 public proposalDeposit; // default = 10 ETH (~$1,000 worth of ETH at contract deployment)
    uint256 public dilutionBound; // default = 3 - maximum multiplier a YES voter will be obligated to pay in case of mass ragequit
    uint256 public processingReward; // default = 0.1 - amount of ETH to give to whoever processes a proposal
    uint256 public summoningTime; // needed to determine the current period

    IERC20 public approvedToken; // approved token contract reference; default = wETH
    GuildBank public guildBank; // guild bank contract reference

    // HARD-CODED LIMITS
    // These numbers are quite arbitrary; they are small enough to avoid overflows when doing calculations
    // with periods or shares, yet big enough to not limit reasonable use cases.
    uint256 constant MAX_VOTING_PERIOD_LENGTH = 10**18; // maximum length of voting period
    uint256 constant MAX_GRACE_PERIOD_LENGTH = 10**18; // maximum length of grace period
    uint256 constant MAX_DILUTION_BOUND = 10**18; // maximum dilution bound
    uint256 constant MAX_NUMBER_OF_SHARES = 10**18; // maximum number of shares that can be minted

    /***************
    EVENTS
    ***************/
    event SubmitProposal(
        uint256 proposalIndex,
        address indexed delegateKey,
        address indexed memberAddress,
        address indexed applicant,
        uint256 tokenTribute,
        uint256 sharesRequested
    );
    event SubmitVote(uint256 indexed proposalIndex, address indexed delegateKey, address indexed memberAddress, uint8 uintVote);
    event ProcessProposal(
        uint256 indexed proposalIndex,
        address indexed applicant,
        address indexed memberAddress,
        uint256 tokenTribute,
        uint256 sharesRequested,
        bool didPass
    );
    event Ragequit(address indexed memberAddress, uint256 sharesToBurn);
    event Abort(uint256 indexed proposalIndex, address applicantAddress);
    event UpdateDelegateKey(address indexed memberAddress, address newDelegateKey);
    event SummonComplete(address indexed summoner, uint256 shares);

    /******************
    INTERNAL ACCOUNTING
    ******************/
    uint256 public totalShares = 0; // total shares across all members
    uint256 public totalSharesRequested = 0; // total shares that have been requested in unprocessed proposals

    enum Vote {
        Null, // default value, counted as abstention
        Yes,
        No
    }

    struct Member {
        address delegateKey; // the key responsible for submitting proposals and voting - defaults to member address unless updated
        uint256 shares; // the # of shares assigned to this member
        bool exists; // always true once a member has been created
        uint256 highestIndexYesVote; // highest proposal index # on which the member voted YES
    }

    struct Proposal {
        address proposer; // the member who submitted the proposal
        address applicant; // the applicant who wishes to become a member - this key will be used for withdrawals
        uint256 sharesRequested; // the # of shares the applicant is requesting
        uint256 startingPeriod; // the period in which voting can start for this proposal
        uint256 yesVotes; // the total number of YES votes for this proposal
        uint256 noVotes; // the total number of NO votes for this proposal
        bool processed; // true only if the proposal has been processed
        bool didPass; // true only if the proposal passed
        bool aborted; // true only if applicant calls "abort" fn before end of voting period
        uint256 tokenTribute; // amount of tokens offered as tribute
        string details; // proposal details - could be IPFS hash, plaintext, or JSON
        uint256 maxTotalSharesAtYesVote; // the maximum # of total shares encountered at a yes vote on this proposal
        mapping (address => Vote) votesByMember; // the votes on this proposal by each member
    }

    mapping (address => Member) public members;
    mapping (address => address) public memberAddressByDelegateKey;
    Proposal[] public proposalQueue;

    /********
    MODIFIERS
    ********/
    modifier onlyMember {
        require(members[msg.sender].shares > 0, "Moloch::onlyMember - not a member");
        _;
    }

    modifier onlyDelegate {
        require(members[memberAddressByDelegateKey[msg.sender]].shares > 0, "Moloch::onlyDelegate - not a delegate");
        _;
    }

    /********
    FUNCTIONS
    ********/
    constructor(
        address summoner,
        address _approvedToken,
        uint256 _periodDuration,
        uint256 _votingPeriodLength,
        uint256 _gracePeriodLength,
        uint256 _abortWindow,
        uint256 _proposalDeposit,
        uint256 _dilutionBound,
        uint256 _processingReward
    ) public {
        require(summoner != address(0), "Moloch::constructor - summoner cannot be 0");
        require(_approvedToken != address(0), "Moloch::constructor - _approvedToken cannot be 0");
        require(_periodDuration > 0, "Moloch::constructor - _periodDuration cannot be 0");
        require(_votingPeriodLength > 0, "Moloch::constructor - _votingPeriodLength cannot be 0");
        require(_votingPeriodLength <= MAX_VOTING_PERIOD_LENGTH, "Moloch::constructor - _votingPeriodLength exceeds limit");
        require(_gracePeriodLength <= MAX_GRACE_PERIOD_LENGTH, "Moloch::constructor - _gracePeriodLength exceeds limit");
        require(_abortWindow > 0, "Moloch::constructor - _abortWindow cannot be 0");
        require(_abortWindow <= _votingPeriodLength, "Moloch::constructor - _abortWindow must be smaller than or equal to _votingPeriodLength");
        require(_dilutionBound > 0, "Moloch::constructor - _dilutionBound cannot be 0");
        require(_dilutionBound <= MAX_DILUTION_BOUND, "Moloch::constructor - _dilutionBound exceeds limit");
        require(_proposalDeposit >= _processingReward, "Moloch::constructor - _proposalDeposit cannot be smaller than _processingReward");

        approvedToken = IERC20(_approvedToken);

        guildBank = new GuildBank(_approvedToken);

        periodDuration = _periodDuration;
        votingPeriodLength = _votingPeriodLength;
        gracePeriodLength = _gracePeriodLength;
        abortWindow = _abortWindow;
        proposalDeposit = _proposalDeposit;
        dilutionBound = _dilutionBound;
        processingReward = _processingReward;

        summoningTime = now;

        members[summoner] = Member(summoner, 1, true, 0);
        memberAddressByDelegateKey[summoner] = summoner;
        totalShares = 1;

        emit SummonComplete(summoner, 1);
    }

    /*****************
    PROPOSAL FUNCTIONS
    *****************/

    function submitProposal(
        address applicant,
        uint256 tokenTribute,
        uint256 sharesRequested,
        string memory details
    )
        public
        onlyDelegate
    {
        require(applicant != address(0), "Moloch::submitProposal - applicant cannot be 0");

        // Make sure we won't run into overflows when doing calculations with shares.
        // Note that totalShares + totalSharesRequested + sharesRequested is an upper bound
        // on the number of shares that can exist until this proposal has been processed.
        require(totalShares.add(totalSharesRequested).add(sharesRequested) <= MAX_NUMBER_OF_SHARES, "Moloch::submitProposal - too many shares requested");

        totalSharesRequested = totalSharesRequested.add(sharesRequested);

        address memberAddress = memberAddressByDelegateKey[msg.sender];

        // collect proposal deposit from proposer and store it in the Moloch until the proposal is processed
        require(approvedToken.transferFrom(msg.sender, address(this), proposalDeposit), "Moloch::submitProposal - proposal deposit token transfer failed");

        // collect tribute from applicant and store it in the Moloch until the proposal is processed
        require(approvedToken.transferFrom(applicant, address(this), tokenTribute), "Moloch::submitProposal - tribute token transfer failed");

        // compute startingPeriod for proposal
        uint256 startingPeriod = max(
            getCurrentPeriod(),
            proposalQueue.length == 0 ? 0 : proposalQueue[proposalQueue.length.sub(1)].startingPeriod
        ).add(1);

        // create proposal ...
        Proposal memory proposal = Proposal({
            proposer: memberAddress,
            applicant: applicant,
            sharesRequested: sharesRequested,
            startingPeriod: startingPeriod,
            yesVotes: 0,
            noVotes: 0,
            processed: false,
            didPass: false,
            aborted: false,
            tokenTribute: tokenTribute,
            details: details,
            maxTotalSharesAtYesVote: 0
        });

        // ... and append it to the queue
        proposalQueue.push(proposal);

        uint256 proposalIndex = proposalQueue.length.sub(1);
        emit SubmitProposal(proposalIndex, msg.sender, memberAddress, applicant, tokenTribute, sharesRequested);
    }

    function submitVote(uint256 proposalIndex, uint8 uintVote) public onlyDelegate {
        address memberAddress = memberAddressByDelegateKey[msg.sender];
        Member storage member = members[memberAddress];

        require(proposalIndex < proposalQueue.length, "Moloch::submitVote - proposal does not exist");
        Proposal storage proposal = proposalQueue[proposalIndex];

        require(uintVote < 3, "Moloch::submitVote - uintVote must be less than 3");
        Vote vote = Vote(uintVote);

        require(getCurrentPeriod() >= proposal.startingPeriod, "Moloch::submitVote - voting period has not started");
        require(!hasVotingPeriodExpired(proposal.startingPeriod), "Moloch::submitVote - proposal voting period has expired");
        require(proposal.votesByMember[memberAddress] == Vote.Null, "Moloch::submitVote - member has already voted on this proposal");
        require(vote == Vote.Yes || vote == Vote.No, "Moloch::submitVote - vote must be either Yes or No");
        require(!proposal.aborted, "Moloch::submitVote - proposal has been aborted");

        // store vote
        proposal.votesByMember[memberAddress] = vote;

        // count vote
        if (vote == Vote.Yes) {
            proposal.yesVotes = proposal.yesVotes.add(member.shares);

            // set highest index (latest) yes vote - must be processed for member to ragequit
            if (proposalIndex > member.highestIndexYesVote) {
                member.highestIndexYesVote = proposalIndex;
            }

            // set maximum of total shares encountered at a yes vote - used to bound dilution for yes voters
            if (totalShares > proposal.maxTotalSharesAtYesVote) {
                proposal.maxTotalSharesAtYesVote = totalShares;
            }

        } else if (vote == Vote.No) {
            proposal.noVotes = proposal.noVotes.add(member.shares);
        }

        emit SubmitVote(proposalIndex, msg.sender, memberAddress, uintVote);
    }

    function processProposal(uint256 proposalIndex) public {
        require(proposalIndex < proposalQueue.length, "Moloch::processProposal - proposal does not exist");
        Proposal storage proposal = proposalQueue[proposalIndex];

        require(getCurrentPeriod() >= proposal.startingPeriod.add(votingPeriodLength).add(gracePeriodLength), "Moloch::processProposal - proposal is not ready to be processed");
        require(proposal.processed == false, "Moloch::processProposal - proposal has already been processed");
        require(proposalIndex == 0 || proposalQueue[proposalIndex.sub(1)].processed, "Moloch::processProposal - previous proposal must be processed");

        proposal.processed = true;
        totalSharesRequested = totalSharesRequested.sub(proposal.sharesRequested);

        bool didPass = proposal.yesVotes > proposal.noVotes;

        // Make the proposal fail if the dilutionBound is exceeded
        if (totalShares.mul(dilutionBound) < proposal.maxTotalSharesAtYesVote) {
            didPass = false;
        }

        // PROPOSAL PASSED
        if (didPass && !proposal.aborted) {

            proposal.didPass = true;

            // if the applicant is already a member, add to their existing shares
            if (members[proposal.applicant].exists) {
                members[proposal.applicant].shares = members[proposal.applicant].shares.add(proposal.sharesRequested);

            // the applicant is a new member, create a new record for them
            } else {
                // if the applicant address is already taken by a member's delegateKey, reset it to their member address
                if (members[memberAddressByDelegateKey[proposal.applicant]].exists) {
                    address memberToOverride = memberAddressByDelegateKey[proposal.applicant];
                    memberAddressByDelegateKey[memberToOverride] = memberToOverride;
                    members[memberToOverride].delegateKey = memberToOverride;
                }

                // use applicant address as delegateKey by default
                members[proposal.applicant] = Member(proposal.applicant, proposal.sharesRequested, true, 0);
                memberAddressByDelegateKey[proposal.applicant] = proposal.applicant;
            }

            // mint new shares
            totalShares = totalShares.add(proposal.sharesRequested);

            // transfer tokens to guild bank
            require(
                approvedToken.transfer(address(guildBank), proposal.tokenTribute),
                "Moloch::processProposal - token transfer to guild bank failed"
            );

        // PROPOSAL FAILED OR ABORTED
        } else {
            // return all tokens to the applicant
            require(
                approvedToken.transfer(proposal.applicant, proposal.tokenTribute),
                "Moloch::processProposal - failing vote token transfer failed"
            );
        }

        // send msg.sender the processingReward
        require(
            approvedToken.transfer(msg.sender, processingReward),
            "Moloch::processProposal - failed to send processing reward to msg.sender"
        );

        // return deposit to proposer (subtract processing reward)
        require(
            approvedToken.transfer(proposal.proposer, proposalDeposit.sub(processingReward)),
            "Moloch::processProposal - failed to return proposal deposit to proposer"
        );

        emit ProcessProposal(
            proposalIndex,
            proposal.applicant,
            proposal.proposer,
            proposal.tokenTribute,
            proposal.sharesRequested,
            didPass
        );
    }

    function ragequit(uint256 sharesToBurn) public onlyMember {
        uint256 initialTotalShares = totalShares;

        Member storage member = members[msg.sender];

        require(member.shares >= sharesToBurn, "Moloch::ragequit - insufficient shares");

        require(canRagequit(member.highestIndexYesVote), "Moloch::ragequit - cant ragequit until highest index proposal member voted YES on is processed");

        // burn shares
        member.shares = member.shares.sub(sharesToBurn);
        totalShares = totalShares.sub(sharesToBurn);

        // instruct guildBank to transfer fair share of tokens to the ragequitter
        require(
            guildBank.withdraw(msg.sender, sharesToBurn, initialTotalShares),
            "Moloch::ragequit - withdrawal of tokens from guildBank failed"
        );

        emit Ragequit(msg.sender, sharesToBurn);
    }

    function abort(uint256 proposalIndex) public {
        require(proposalIndex < proposalQueue.length, "Moloch::abort - proposal does not exist");
        Proposal storage proposal = proposalQueue[proposalIndex];

        require(msg.sender == proposal.applicant, "Moloch::abort - msg.sender must be applicant");
        require(getCurrentPeriod() < proposal.startingPeriod.add(abortWindow), "Moloch::abort - abort window must not have passed");
        require(!proposal.aborted, "Moloch::abort - proposal must not have already been aborted");

        uint256 tokensToAbort = proposal.tokenTribute;
        proposal.tokenTribute = 0;
        proposal.aborted = true;

        // return all tokens to the applicant
        require(
            approvedToken.transfer(proposal.applicant, tokensToAbort),
            "Moloch::processProposal - failed to return tribute to applicant"
        );

        emit Abort(proposalIndex, msg.sender);
    }

    function updateDelegateKey(address newDelegateKey) public onlyMember {
        require(newDelegateKey != address(0), "Moloch::updateDelegateKey - newDelegateKey cannot be 0");

        // skip checks if member is setting the delegate key to their member address
        if (newDelegateKey != msg.sender) {
            require(!members[newDelegateKey].exists, "Moloch::updateDelegateKey - cant overwrite existing members");
            require(!members[memberAddressByDelegateKey[newDelegateKey]].exists, "Moloch::updateDelegateKey - cant overwrite existing delegate keys");
        }

        Member storage member = members[msg.sender];
        memberAddressByDelegateKey[member.delegateKey] = address(0);
        memberAddressByDelegateKey[newDelegateKey] = msg.sender;
        member.delegateKey = newDelegateKey;

        emit UpdateDelegateKey(msg.sender, newDelegateKey);
    }

    /***************
    GETTER FUNCTIONS
    ***************/

    function max(uint256 x, uint256 y) internal pure returns (uint256) {
        return x >= y ? x : y;
    }

    function getCurrentPeriod() public view returns (uint256) {
        return now.sub(summoningTime).div(periodDuration);
    }

    function getProposalQueueLength() public view returns (uint256) {
        return proposalQueue.length;
    }

    // can only ragequit if the latest proposal you voted YES on has been processed
    function canRagequit(uint256 highestIndexYesVote) public view returns (bool) {
        require(highestIndexYesVote < proposalQueue.length, "Moloch::canRagequit - proposal does not exist");
        return proposalQueue[highestIndexYesVote].processed;
    }

    function hasVotingPeriodExpired(uint256 startingPeriod) public view returns (bool) {
        return getCurrentPeriod() >= startingPeriod.add(votingPeriodLength);
    }

    function getMemberProposalVote(address memberAddress, uint256 proposalIndex) public view returns (Vote) {
        require(members[memberAddress].exists, "Moloch::getMemberProposalVote - member doesn't exist");
        require(proposalIndex < proposalQueue.length, "Moloch::getMemberProposalVote - proposal doesn't exist");
        return proposalQueue[proposalIndex].votesByMember[memberAddress];
    }
}




contract TrojanPool {
    using SafeMath for uint256;

    event Sync (
        uint256 currentProposalIndex
    );

    event Deposit (
        address donor,
        uint256 sharesMinted,
        uint256 tokensDeposited
    );

    event Withdraw (
        address donor,
        uint256 sharesBurned
    );

    event KeeperWithdraw (
        address donor,
        uint256 sharesBurned,
        address keeper
    );

    event AddKeepers (
        address donor,
        address[] addedKeepers
    );

    event RemoveKeepers (
        address donor,
        address[] removedKeepers
    );

    event SharesMinted (
        uint256 sharesToMint,
        address recipient,
        uint256 totalPoolShares
    );

    event SharesBurned (
        uint256 sharesToBurn,
        address recipient,
        uint256 totalPoolShares
    );

    uint256 public totalPoolShares = 0; // the total shares outstanding of the pool
    uint256 public currentProposalIndex = 0; // the moloch proposal index that this pool has been synced to

    TrojanDao public trojan; // moloch contract reference
    IERC20 public approvedToken; // approved token contract reference (copied from moloch contract)

    bool locked; // prevent re-entrancy

    uint256 constant MAX_NUMBER_OF_SHARES = 10**30; // maximum number of shares that can be minted

    struct Donor {
        uint256 shares;
        mapping (address => bool) keepers;
    }

    // the amount of shares each pool shareholder has
    mapping (address => Donor) public donors;

    modifier active {
        require(totalPoolShares > 0, "MolochPool: Not active");
        _;
    }

    modifier noReentrancy() {
        require(!locked, "MolochPool: Reentrant call");
        locked = true;
        _;
        locked = false;
    }

    constructor(address _moloch) public {
        trojan = TrojanDao(_moloch);
        approvedToken = IERC20(trojan.approvedToken());
    }

    function activate(uint256 initialTokens, uint256 initialPoolShares) public noReentrancy {
        require(totalPoolShares == 0, "MolochPool: Already active");

        require(
            approvedToken.transferFrom(msg.sender, address(this), initialTokens),
            "MolochPool: Initial tokens transfer failed"
        );
        _mintSharesForAddress(initialPoolShares, msg.sender);
    }

    // updates Pool state based on Moloch proposal queue
    // - we only want to mint shares for grants, which are 0 tribute
    // - mints pool shares to applicants based on sharesRequested / maxTotalSharesAtYesVote
    // - use maxTotalSharesAtYesVote because:
    //   - cant read shares at the time of proposal processing (womp womp)
    //   - should be close enough if grant shares are small relative to total shares, which they should be
    //   - protects pool contributors if many Moloch members ragequit before the proposal is processed by reducing follow on funding
    //   - e.g. if 50% of Moloch shares ragequit after someone voted yes, the grant proposal would get 50% less follow-on from the pool
    function sync(uint256 toIndex) public active noReentrancy {
        require(
            toIndex <= trojan.getProposalQueueLength(),
            "MolochPool: Proposal index too high"
        );

        // declare proposal params
        address applicant;
        uint256 sharesRequested;
        bool processed;
        bool didPass;
        bool aborted;
        uint256 tokenTribute;
        uint256 maxTotalSharesAtYesVote;

        uint256 i = currentProposalIndex;

        while (i < toIndex) {

            (, applicant, sharesRequested, , , , processed, didPass, aborted, tokenTribute, , maxTotalSharesAtYesVote) = trojan.proposalQueue(i);

            if (!processed) {
                break;
            }

            // passing grant proposal, mint pool shares proportionally on behalf of the applicant
            if (!aborted && didPass && tokenTribute == 0 && sharesRequested > 0) {
                // This can't revert:
                //   1. maxTotalSharesAtYesVote > 0, otherwise nobody could have voted.
                //   2. sharesRequested is <= 10**18 (see Moloch.sol:172), and
                //      totalPoolShares <= 10**30, so multiplying them is <= 10**48 and < 2**160
                uint256 sharesToMint = totalPoolShares.mul(sharesRequested).div(maxTotalSharesAtYesVote); // for a passing proposal, maxTotalSharesAtYesVote is > 0
                _mintSharesForAddress(sharesToMint, applicant);
            }

            i++;
        }

        currentProposalIndex = i;

        emit Sync(currentProposalIndex);
    }

    // add tokens to the pool, mint new shares proportionally
    function deposit(uint256 tokenAmount) public active noReentrancy {

        uint256 sharesToMint = totalPoolShares.mul(tokenAmount).div(approvedToken.balanceOf(address(this)));

        require(
            approvedToken.transferFrom(msg.sender, address(this), tokenAmount),
            "MolochPool: Deposit transfer failed"
        );

        _mintSharesForAddress(sharesToMint, msg.sender);

        emit Deposit(
            msg.sender,
            sharesToMint,
            tokenAmount
        );
    }

    // burn shares to proportionally withdraw tokens in pool
    function withdraw(uint256 sharesToBurn) public active noReentrancy {
        _withdraw(msg.sender, sharesToBurn);

        emit Withdraw(
            msg.sender,
            sharesToBurn
        );
    }

    // keeper burns shares to withdraw on behalf of the donor
    function keeperWithdraw(uint256 sharesToBurn, address recipient) public active noReentrancy {
        require(
            donors[recipient].keepers[msg.sender],
            "MolochPool: Sender is not a keeper"
        );

        _withdraw(recipient, sharesToBurn);

        emit KeeperWithdraw(
            recipient,
            sharesToBurn,
            msg.sender
        );
    }

    function addKeepers(address[] calldata newKeepers) external active noReentrancy {
        Donor storage donor = donors[msg.sender];

        for (uint256 i = 0; i < newKeepers.length; i++) {
            donor.keepers[newKeepers[i]] = true;
        }

        emit AddKeepers(msg.sender, newKeepers);
    }

    function removeKeepers(address[] calldata keepersToRemove) external active noReentrancy {
        Donor storage donor = donors[msg.sender];

        for (uint256 i = 0; i < keepersToRemove.length; i++) {
            donor.keepers[keepersToRemove[i]] = false;
        }

        emit RemoveKeepers(msg.sender, keepersToRemove);
    }

    function _mintSharesForAddress(uint256 sharesToMint, address recipient) internal {
        totalPoolShares = totalPoolShares.add(sharesToMint);
        donors[recipient].shares = donors[recipient].shares.add(sharesToMint);

        require(
            totalPoolShares <= MAX_NUMBER_OF_SHARES,
            "MolochPool: Max number of shares exceeded"
        );

        emit SharesMinted(
            sharesToMint,
            recipient,
            totalPoolShares
        );
    }

    function _withdraw(address recipient, uint256 sharesToBurn) internal {
        Donor storage donor = donors[recipient];

        require(
            donor.shares >= sharesToBurn,
            "MolochPool: Not enough shares to burn"
        );

        uint256 tokensToWithdraw = approvedToken.balanceOf(address(this)).mul(sharesToBurn).div(totalPoolShares);

        totalPoolShares = totalPoolShares.sub(sharesToBurn);
        donor.shares = donor.shares.sub(sharesToBurn);

        require(
            approvedToken.transfer(recipient, tokensToWithdraw),
            "MolochPool: Withdrawal transfer failed"
        );

        emit SharesBurned(
            sharesToBurn,
            recipient,
            totalPoolShares
        );
    }

}


contract TrojanToken is ERC20Detailed {

    using SafeMath for uint256;
    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowed;

    event TrojanRedistribution(address from, uint amount);
    event Mint(address to, uint amount);
    event Sell(address from, uint amount);
    event DaoTax(uint256 amount);

    //uint256 public constant MAX_SUPPLY = 400000000 * 10 ** 18; // 40000 ETH of Sparkle
    uint256 public constant PERCENT = 100; // 100%
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
        // mintTrojan();
    }

    function mintTrojan(uint256 amount) public payable returns (bool) {
        //uint256 amount = msg.value.mul(10 ** 18).div(COST_PER_TOKEN);
        //require(_totalSupply.add(amount) <= MAX_SUPPLY, "Max supply reached");

        // Gets the price (in collateral) for the tokens
        uint256 priceForTokens = priceToMint(amount);

        // Ensures there is no overflow
        require(priceForTokens > 0, "Tokens requested too low");

        // Sends the collateral from the buyer to this market
        require(
            collateralToken_.transferFrom(
                msg.sender,
                address(this),
                priceForTokens
            ),
            "Collateral transfer failed"
        );

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

        //uint256 reward = amount.mul(COST_PER_TOKEN).div(10 ** 18);
        uint256 reward = rewardForBurn(amount);

        uint256 taxAmount = reward.mul(BURN_TAX).div(PERCENT);
        uint256 sellerAmount = reward.sub(taxAmount);

        require(
            collateralToken_.transfer(
                msg.sender,
                sellerAmount
            ),
            "Tokens not sent"
        );

        _balances[msg.sender] = balanceOf(msg.sender).sub(amount);
        _tobinsClaimed[msg.sender] = _tobinsCollected;

        // need to add to this contract balance so that it can deposit into the dao
        _balances[address(this)] = balanceOf(address(this)).add(taxAmount);

        _totalSupply = _totalSupply.sub(amount);

        // deposit tax to trojan pool
        daoTax(taxAmount);

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
            _curveIntegral(_totalSupply).add(_collateralTokenOffered)
        ).sub(_totalSupply);
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
            _totalSupply.sub(
                _inverseCurveIntegral(
                    _curveIntegral(_totalSupply).sub(_collateralTokenNeeded)
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