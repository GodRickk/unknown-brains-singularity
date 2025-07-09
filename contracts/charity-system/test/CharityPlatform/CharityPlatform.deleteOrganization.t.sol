// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";

import {Ownable} from "@openzeppelin/access/Ownable.sol";

import {CharityPlatform} from "../../src/CharityPlatform.sol";
import {ICharityPlatform} from "../../src/interfaces/ICharityPlatform.sol";
import {SetUpCharityPlatform} from "./_setUp.t.sol";

contract DonateETH is SetUpCharityPlatform {
    function setUp() public override {
        super.setUp();
    }

    function test_deleteOrganization() public {
        vm.prank(owner);
        charityPlatform.deleteOrganization(organizationName);

        assertEq(charityPlatform.charities(organizationName), address(0));
    }

    function test_RevertWhen_NotOwner() public {
        vm.expectRevert(abi.encodeWithSelector(Ownable.OwnableUnauthorizedAccount.selector, notOwner));

        vm.prank(notOwner);
        charityPlatform.deleteOrganization(organizationName);
    }

    function test_RevertWhen_IsNotDefined() public {
        vm.expectRevert(
            abi.encodeWithSelector(ICharityPlatform.CharityOrganizationIsNotDefined.selector, notDefinedName)
        );

        vm.prank(owner);
        charityPlatform.deleteOrganization(notDefinedName);
    }
}
