pragma solidity 0.5.11;

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
