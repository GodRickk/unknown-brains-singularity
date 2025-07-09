// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {Test} from "forge-std/Test.sol";
import {SetUpCharityPlatform} from "../../_setUp.t.sol";

contract GetFee is SetUpCharityPlatform {
    function setUp() public override {
        super.setUp();
    }

    function test_ReturnInitialFeeValue() public view {
        uint256 expectedFee = 3_00;
        assertEq(charityPlatform.getFee(), expectedFee);
    }

    function test_ReturnUpdatedFeeValue() public {
        uint256 newFee = 2_00;

        vm.prank(owner);
        charityPlatform.setFee(newFee);

        assertEq(charityPlatform.getFee(), newFee);
    }
}
