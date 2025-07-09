// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {Test} from "forge-std/Test.sol";

import {IERC20} from "@openzeppelin/token/ERC20/IERC20.sol";

import {CharityPlatform} from "../../src/CharityPlatform.sol";

import {Fork} from "../../utils/Fork.sol";

contract SetUpCharityPlatform is Test, Fork {
    CharityPlatform public charityPlatform;

    address owner = makeAddr("owner");
    address notOwner = makeAddr("notOwner");

    address charityReceiver = makeAddr("charityReceiver");
    string organizationName = "Some Name";
    string notDefinedName = "Not defined";

    address charityDonor = makeAddr("charityDonor");

    address feeReceiver = makeAddr("feeReceiver");

    address ARBITRUM_USDT = 0xFd086bC7CD5C481DCC9C85ebE478A1C0b69FCbb9;

    function setUp() public virtual {
        uint256 forkId = vm.createSelectFork(vm.envString("ARBITRUM_MAINNET_RPC_URL"));
        charityPlatform = new CharityPlatform(owner, feeReceiver);

        vm.prank(owner);
        charityPlatform.registerOrganization(organizationName, charityReceiver);
    }
}
