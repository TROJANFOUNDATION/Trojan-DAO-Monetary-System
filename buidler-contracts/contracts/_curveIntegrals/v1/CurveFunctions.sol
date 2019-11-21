pragma solidity 0.5.11;

import { SafeMath } from "../../lib/SafeMath.sol";

// @author Ben Scholtz @ Linum Labs
// @title Bonding curve functions

contract CurveFunctions {
	using SafeMath for uint256;

	string constant public curveFunction = "linear: (1/20000)*x + 0.5";
	uint256 constant public DECIMALS = 18;

	/**
      * @dev    Calculates the definite integral of the curve
      * @param  _x : Token value for upper limit of definite integral
      */
	function curveIntegral(uint256 _x) public pure returns (uint256) {
		require(_x >= 0, 'Input argument too small');
		require(_x < 10**41, 'Input argument too large');

		// Calculate equation arguments
		uint256 x = _x.mul(10**(DECIMALS.sub(18)));
		uint256 a = 25*10**(DECIMALS - 6);
		uint256 b = 5*10**(DECIMALS - 1);

		// curve integral: (0.000025*x + 0.5)*x
		return (a.mul(x).div(10**DECIMALS).add(b)).mul(x).div(10**DECIMALS);
	}

	/**
		* @dev    Calculates the definite inverse integral of the curve
		* @param  _x : collateral value for upper limit of definite integral
		*/
	function inverseCurveIntegral(uint256 _x) public pure returns(uint256) {
		require(_x >= 0, 'Input argument too small');

		// Use 36 decimal places for square root precision
		uint256 DECIMALS_36 = 36;

		// Calculate equation arguments
		uint256 x = _x*10**DECIMALS;
		uint256 prefix = 200*10**DECIMALS_36;
		uint256 a = prefix
			.mul(sqrt(x + 2500*10**DECIMALS_36))
			.div(sqrt(10**DECIMALS_36));

		// inverse curve integral: -10000 + 200*sqrt(x + 2500)
		return uint256(
				-10000*int256(10**DECIMALS_36) + int256(a)
			).div(10**DECIMALS);
	}

	function sqrt(uint256 _x) public pure returns (uint256) {
		if (_x == 0) return 0;
		else if (_x <= 3) return 1;
		uint256 z = (_x + 1) / 2;
		uint256 y = _x;
		while (z < y)
		{
		y = z;
		z = (_x / z + z) / 2;
		}
		return y;
	}
}