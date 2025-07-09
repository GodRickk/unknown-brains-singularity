// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";

import {IERC20} from "@openzeppelin/token/ERC20/IERC20.sol";

import {CharityPlatform} from "../../src/CharityPlatform.sol";
import {ICharityPlatform} from "../../src/interfaces/ICharityPlatform.sol";

import {SetUpCharityPlatform} from "./_setUp.t.sol";

contract DonateToken is SetUpCharityPlatform {
    uint256 tokenDonateAmount = 10 ether;

    function setUp() public override {
        super.setUp();
    }

    function test_donateToken() public {
        prepareToDonateToken(notOwner, ARBITRUM_USDT, tokenDonateAmount);

        vm.prank(notOwner);
        charityPlatform.donateToken(organizationName, ARBITRUM_USDT, tokenDonateAmount);

        assertEq(IERC20(ARBITRUM_USDT).balanceOf(notOwner), 0);
        assertEq(IERC20(ARBITRUM_USDT).balanceOf(address(charityPlatform)), 0);
        assertEq(IERC20(ARBITRUM_USDT).balanceOf(charityReceiver), tokenDonateAmount);
    }

    function testFuzz_donateToken(uint256 amount) public {
        vm.assume(amount > 0 && amount < 100 ether);

        deal(ARBITRUM_USDT, notOwner, amount);

        vm.prank(notOwner);
        IERC20(ARBITRUM_USDT).approve(address(charityPlatform), amount);

        vm.prank(notOwner);
        charityPlatform.donateToken(organizationName, ARBITRUM_USDT, amount);

        assertEq(IERC20(ARBITRUM_USDT).balanceOf(notOwner), 0);
        assertEq(IERC20(ARBITRUM_USDT).balanceOf(address(charityPlatform)), 0);
        assertEq(IERC20(ARBITRUM_USDT).balanceOf(charityReceiver), amount);
    }

    function test_RevertWhen_OrganizationIsNotDefined() public {
        prepareToDonateToken(notOwner, ARBITRUM_USDT, tokenDonateAmount);

        vm.expectRevert(
            abi.encodeWithSelector(ICharityPlatform.CharityOrganizationIsNotDefined.selector, notDefinedName)
        );
        vm.prank(notOwner);
        charityPlatform.donateToken(notDefinedName, ARBITRUM_USDT, tokenDonateAmount);
    }

    function test_RevertWhen_ZeroTokenAddress() public {
        prepareToDonateToken(notOwner, ARBITRUM_USDT, tokenDonateAmount);

        vm.expectRevert(abi.encodeWithSelector(ICharityPlatform.ZeroAddress.selector));
        vm.prank(notOwner);
        charityPlatform.donateToken(organizationName, address(0), tokenDonateAmount);
    }

    function test_RevertWhen_ZeroTokenAmount() public {
        prepareToDonateToken(notOwner, ARBITRUM_USDT, tokenDonateAmount);

        vm.expectRevert(abi.encodeWithSelector(ICharityPlatform.ZeroAmount.selector));
        vm.prank(notOwner);
        charityPlatform.donateToken(organizationName, ARBITRUM_USDT, 0);
    }

    function prepareToDonateToken(address caller, address tokenAddress, uint256 tokenAmount) internal {
        deal(tokenAddress, caller, tokenAmount);

        vm.prank(caller);
        IERC20(tokenAddress).approve(address(charityPlatform), tokenAmount);
    }
}
