// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

interface IErrors {
    error CharityOrganizationIsNotDefined(string name);

    error ZeroAddress();

    error ZeroAmount();
}
