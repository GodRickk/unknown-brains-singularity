// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";

import {IERC20} from "@openzeppelin/token/ERC20/IERC20.sol";

import {CharityPlatform} from "../../src/CharityPlatform.sol";
import {ICharityPlatform} from "../../src/interfaces/ICharityPlatform.sol";
import {IErrors} from "../../src/interfaces/IErrors.sol";

import {SetUpCharityPlatform} from "./_setUp.t.sol";

contract DonateToken is SetUpCharityPlatform {
    uint256 tokenDonateAmount = 10 ether;

    function setUp() public override {
        super.setUp();
    }

    function test_donateToken() public {
        prepareToDonateToken(notOwner, ARBITRUM_USDT, tokenDonateAmount);

        uint256 feeAmount = charityPlatform.calculateFee(tokenDonateAmount);

        vm.prank(notOwner);
        charityPlatform.donateToken(organizationName, ARBITRUM_USDT, tokenDonateAmount);

        assertEq(IERC20(ARBITRUM_USDT).balanceOf(notOwner), 0);

        assertEq(IERC20(ARBITRUM_USDT).balanceOf(address(charityPlatform)), 0);
        assertEq(IERC20(ARBITRUM_USDT).balanceOf(charityPlatform.getFeeReceiver()), feeAmount);

        assertEq(IERC20(ARBITRUM_USDT).balanceOf(charityReceiver), tokenDonateAmount - feeAmount);
    }

    function testFuzz_donateToken(uint256 donationAmount) public {
        vm.assume(donationAmount > 0 && donationAmount < 100 ether);

        deal(ARBITRUM_USDT, notOwner, donationAmount);

        uint256 feeAmount = charityPlatform.calculateFee(donationAmount);

        vm.prank(notOwner);
        IERC20(ARBITRUM_USDT).approve(address(charityPlatform), donationAmount);

        vm.prank(notOwner);
        charityPlatform.donateToken(organizationName, ARBITRUM_USDT, donationAmount);

        assertEq(IERC20(ARBITRUM_USDT).balanceOf(notOwner), 0);

        assertEq(IERC20(ARBITRUM_USDT).balanceOf(address(charityPlatform)), 0);
        assertEq(IERC20(ARBITRUM_USDT).balanceOf(charityPlatform.getFeeReceiver()), feeAmount);

        assertEq(IERC20(ARBITRUM_USDT).balanceOf(charityReceiver), donationAmount - feeAmount);
    }

    function test_RevertWhen_OrganizationIsNotDefined() public {
        prepareToDonateToken(notOwner, ARBITRUM_USDT, tokenDonateAmount);

        vm.expectRevert(abi.encodeWithSelector(IErrors.CharityOrganizationIsNotDefined.selector, notDefinedName));
        vm.prank(notOwner);
        charityPlatform.donateToken(notDefinedName, ARBITRUM_USDT, tokenDonateAmount);
    }

    function test_RevertWhen_ZeroTokenAddress() public {
        prepareToDonateToken(notOwner, ARBITRUM_USDT, tokenDonateAmount);

        vm.expectRevert(abi.encodeWithSelector(IErrors.ZeroAddress.selector));
        vm.prank(notOwner);
        charityPlatform.donateToken(organizationName, address(0), tokenDonateAmount);
    }

    function test_RevertWhen_ZeroTokenAmount() public {
        prepareToDonateToken(notOwner, ARBITRUM_USDT, tokenDonateAmount);

        vm.expectRevert(abi.encodeWithSelector(IErrors.ZeroAmount.selector));
        vm.prank(notOwner);
        charityPlatform.donateToken(organizationName, ARBITRUM_USDT, 0);
    }

    function prepareToDonateToken(address caller, address tokenAddress, uint256 tokenAmount) internal {
        deal(tokenAddress, caller, tokenAmount);

        vm.prank(caller);
        IERC20(tokenAddress).approve(address(charityPlatform), tokenAmount);
    }
}
