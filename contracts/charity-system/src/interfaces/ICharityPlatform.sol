// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

interface ICharityPlatform {
    event CharityRegistered(address indexed wallet, string name);

    event DonationReceived(address indexed donor, address indexed charity, uint256 amount, address token);
}
