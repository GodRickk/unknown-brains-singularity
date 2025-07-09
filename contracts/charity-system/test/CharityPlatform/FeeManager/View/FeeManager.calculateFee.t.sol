// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {Test} from "forge-std/Test.sol";
import {SetUpCharityPlatform} from "../../_setUp.t.sol";

contract CalculateFee is SetUpCharityPlatform {
    function setUp() public override {
        super.setUp();
    }

    function test_CalculateCorrectFeeAmount() public view {
        uint256 amount = 1000;
        uint256 expectedFee = (amount * charityPlatform.getFee()) / charityPlatform.getFeePrecision();

        assertEq(charityPlatform.calculateFee(amount), expectedFee);
    }

    function testFuzz_CalculateCorrectFeeAmount(uint256 amount) public view {
        vm.assume(amount > 0 && amount < type(uint256).max / charityPlatform.getFeePrecision());

        uint256 expectedFee = (amount * charityPlatform.getFee()) / charityPlatform.getFeePrecision();

        assertEq(charityPlatform.calculateFee(amount), expectedFee);
    }

    function test_ReturnZeroForZeroAmount() public view {
        uint256 amount = 0;

        assertEq(charityPlatform.calculateFee(amount), 0);
    }
}
