// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {Test} from "forge-std/Test.sol";
import {SetUpCharityPlatform} from "../../_setUp.t.sol";

import {Ownable} from "@openzeppelin/access/Ownable.sol";

contract SetFee is SetUpCharityPlatform {
    function setUp() public override {
        super.setUp();
    }

    function test_UpdateFeeToValidValue() public {
        uint256 newFee = 5_00;

        vm.prank(owner);
        charityPlatform.setFee(newFee);

        assertEq(charityPlatform.getFee(), newFee);
    }

    function test_RevertWhen_CallerIsNotOwner() public {
        uint256 newFee = 5_00;

        vm.expectRevert(abi.encodeWithSelector(Ownable.OwnableUnauthorizedAccount.selector, notOwner));

        vm.prank(notOwner);
        charityPlatform.setFee(newFee);
    }

    function test_RevertWhen_FeeExceedsFeePrecision() public {
        uint256 newFee = charityPlatform.getFeePrecision() + 1;

        vm.expectRevert("FeeManager: Fee must be less than or equal to feePrecision");

        vm.prank(owner);
        charityPlatform.setFee(newFee);
    }
}
