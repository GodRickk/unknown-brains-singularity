// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";

import {Ownable} from "@openzeppelin/access/Ownable.sol";

import {CharityPlatform} from "../../src/CharityPlatform.sol";
import {ICharityPlatform} from "../../src/interfaces/ICharityPlatform.sol";
import {SetUpCharityPlatform} from "./_setUp.t.sol";

contract DonateETH is SetUpCharityPlatform {
    string newOrganizationName = "New Organization";
    string shortName = "AB";

    address newOrganizationWallet = makeAddr(newOrganizationName);

    function setUp() public override {
        super.setUp();
    }

    function test_registerOrganization() public {
        vm.prank(owner);
        charityPlatform.registerOrganization(newOrganizationName, newOrganizationWallet);

        assertTrue(charityPlatform.isOrganizationRegistered(newOrganizationName));
    }

    function test_RevertWhen_NotOwner() public {
        vm.expectRevert(abi.encodeWithSelector(Ownable.OwnableUnauthorizedAccount.selector, notOwner));

        vm.prank(notOwner);
        charityPlatform.registerOrganization(newOrganizationName, newOrganizationWallet);
    }

    function test_RevertWhen_AlreadyRegistered() public {
        vm.expectRevert("CharityPlatform: Organization with such name already registered");

        vm.prank(owner);
        charityPlatform.registerOrganization(organizationName, newOrganizationWallet);
    }

    function test_RevertWhen_OrganizationNameShort() public {
        vm.expectRevert("CharityPlatform: Organization name length must be more than 2 symbols");

        vm.prank(owner);
        charityPlatform.registerOrganization(shortName, newOrganizationWallet);
    }
}
