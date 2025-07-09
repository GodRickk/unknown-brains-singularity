// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";

import {IERC20} from "@openzeppelin/token/ERC20/IERC20.sol";

import {CharityPlatform} from "../../src/CharityPlatform.sol";
import {ICharityPlatform} from "../../src/interfaces/ICharityPlatform.sol";
import {IErrors} from "../../src/interfaces/IErrors.sol";

import {SetUpCharityPlatform} from "./_setUp.t.sol";

contract DonateETH is SetUpCharityPlatform {
    uint256 ethDonateAmount = 10 ether;

    function setUp() public override {
        super.setUp();
    }

    function test_donateETH() public {
        vm.deal(notOwner, ethDonateAmount);

        uint256 feeAmount = charityPlatform.calculateFee(ethDonateAmount);

        vm.prank(notOwner);
        charityPlatform.donateETH{value: ethDonateAmount}(organizationName);

        assertEq(notOwner.balance, 0);

        assertEq(address(charityPlatform).balance, 0);
        assertEq(charityPlatform.getFeeReceiver().balance, feeAmount);

        assertEq(charityReceiver.balance, ethDonateAmount - feeAmount);
    }

    function testFuzz_donateETH(uint256 donationAmount) public {
        vm.assume(donationAmount > 0 && donationAmount < 100 ether);

        vm.deal(notOwner, donationAmount);

        uint256 feeAmount = charityPlatform.calculateFee(donationAmount);

        vm.prank(notOwner);
        charityPlatform.donateETH{value: donationAmount}(organizationName);

        assertEq(notOwner.balance, 0);

        assertEq(address(charityPlatform).balance, 0);
        assertEq(charityPlatform.getFeeReceiver().balance, feeAmount);

        assertEq(charityReceiver.balance, donationAmount - feeAmount);
    }

    function test_RevertWhen_OrganizationIsNotDefined() public {
        vm.deal(notOwner, ethDonateAmount);

        vm.expectRevert(abi.encodeWithSelector(IErrors.CharityOrganizationIsNotDefined.selector, notDefinedName));
        vm.prank(notOwner);
        charityPlatform.donateETH{value: ethDonateAmount}(notDefinedName);
    }

    function test_RevertWhen_ZeroTokenAmount() public {
        vm.deal(notOwner, ethDonateAmount);

        vm.expectRevert(abi.encodeWithSelector(IErrors.ZeroAmount.selector));
        vm.prank(notOwner);
        charityPlatform.donateETH{value: 0}(organizationName);
    }
}
