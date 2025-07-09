// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "@openzeppelin/access/Ownable.sol";
import "@openzeppelin/token/ERC20/IERC20.sol";

import {IErrors} from "./interfaces/IErrors.sol";

abstract contract FeeManager is Ownable, IErrors {
    /* ======== STATE ======== */

    address private _feeReceiver;

    uint256 private _fee = 3_00;
    uint256 private _feePrecision = 10_000;

    /* ======== CONSTRUCTOR AND INIT ======== */

    constructor(address admin, address feeReceiver) Ownable(admin) {
        isZeroAddress(feeReceiver);
        isZeroAddress(admin);

        _feeReceiver = feeReceiver;
    }

    /* ======== INTERNAL ======== */

    /**
     * @param amountIn - value where fee got
     * @param token - token address
     * @param isETH - flag if it is donate with native
     */
    function _prepareToDonate(uint256 amountIn, address token, bool isETH) internal returns (uint256) {
        ///@dev  calculate fee and amount in with fee
        (uint256 feeAmount, uint256 amountWithPaidFee) = calculateFeeAndAmounts(amountIn);

        _transferFee(feeAmount, token, isETH);

        return (amountWithPaidFee);
    }

    function _transferFee(uint256 feeAmount, address token, bool isETH) internal {
        if (isETH) {
            (bool sent,) = payable(getFeeReceiver()).call{value: feeAmount}("");
            require(sent, "FeeManager: ETH fee transfer to feeReceiver failed");
        } else {
            IERC20(token).transferFrom(msg.sender, getFeeReceiver(), feeAmount);
        }
    }

    /* ======== ADMIN ======== */

    function setFee(uint256 newFee) external onlyOwner {
        require(newFee <= _feePrecision, "FeeManager: Fee must be less than or equal to feePrecision");
        _fee = newFee;
    }

    /* ======== VIEW ======== */

    function calculateFee(uint256 amount) public view returns (uint256) {
        return (amount * _fee) / _feePrecision;
    }

    function calculateFeeAndAmounts(uint256 amount)
        public
        view
        returns (uint256 feeAmount, uint256 amountWithPaidFee)
    {
        feeAmount = calculateFee(amount);
        amountWithPaidFee = amount - feeAmount;
    }

    function getFee() public view returns (uint256) {
        return _fee;
    }

    function getFeePrecision() public view returns (uint256) {
        return _feePrecision;
    }

    function getFeeReceiver() public view returns (address) {
        return _feeReceiver;
    }

    function isZeroAddress(address addressCheck) public pure {
        if (addressCheck == address(0)) {
            revert ZeroAddress();
        }
    }

    function isZeroAmount(uint256 amount) public pure {
        if (amount == 0) {
            revert ZeroAmount();
        }
    }
}
