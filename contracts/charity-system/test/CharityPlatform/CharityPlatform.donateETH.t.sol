// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";

import {IERC20} from "@openzeppelin/token/ERC20/IERC20.sol";

import {CharityPlatform} from "../../src/CharityPlatform.sol";
import {ICharityPlatform} from "../../src/interfaces/ICharityPlatform.sol";

import {SetUpCharityPlatform} from "./_setUp.t.sol";

contract DonateETH is SetUpCharityPlatform {
    uint256 ethDonateAmount = 10 ether;

    function setUp() public override {
        super.setUp();
    }

    function test_donateETH() public {
        vm.deal(notOwner, ethDonateAmount);

        vm.prank(notOwner);
        charityPlatform.donateETH{value: ethDonateAmount}(organizationName);

        assertEq(notOwner.balance, 0);
        assertEq(address(charityPlatform).balance, 0);
        assertEq(charityReceiver.balance, ethDonateAmount);
    }

    function testFuzz_donateETH(uint256 amount) public {
        vm.assume(amount > 0 && amount < 100 ether);

        vm.deal(notOwner, amount);

        vm.prank(notOwner);
        charityPlatform.donateETH{value: amount}(organizationName);

        assertEq(notOwner.balance, 0);
        assertEq(address(charityPlatform).balance, 0);
        assertEq(charityReceiver.balance, amount);
    }

    function test_RevertWhen_OrganizationIsNotDefined() public {
        vm.deal(notOwner, ethDonateAmount);

        vm.expectRevert(
            abi.encodeWithSelector(ICharityPlatform.CharityOrganizationIsNotDefined.selector, notDefinedName)
        );
        vm.prank(notOwner);
        charityPlatform.donateETH{value: ethDonateAmount}(notDefinedName);
    }

    function test_RevertWhen_ZeroTokenAmount() public {
        vm.deal(notOwner, ethDonateAmount);

        vm.expectRevert(abi.encodeWithSelector(ICharityPlatform.ZeroAmount.selector));
        vm.prank(notOwner);
        charityPlatform.donateETH{value: 0}(organizationName);
    }
}
