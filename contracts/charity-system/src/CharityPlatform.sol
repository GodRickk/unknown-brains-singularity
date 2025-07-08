// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

/* ====== EXTERNAL IMPORTS ====== */
import {Ownable} from "@openzeppelin/access/Ownable.sol";

/* ====== INTERFACES IMPORTS ====== */
import {IERC20} from "@openzeppelin/token/ERC20/IERC20.sol";
import {ICharityPlatform} from "./interfaces/ICharityPlatform.sol";

/* ====== CONTRACTS IMPORTS ====== */

contract CharityPlatform is Ownable, ICharityPlatform {
    /* ======== STATE ======== */

    mapping(string => address) public charities;

    /* ======== CONSTRUCTOR AND INIT ======== */

    constructor(address admin) Ownable(admin) {}

    /* ======== EXTERNAL/PUBLIC ======== */

    /**
     * @dev Donor approves this contract to spend tokens before calling this
     */
    function donateToken(string calldata organizationName, address addressToken, uint256 amount) external {
        isOrganizationRegistered(organizationName);

        isZeroAddress(addressToken);

        isZeroAmount(amount);

        IERC20 token = IERC20(addressToken);

        bool success = token.transferFrom(msg.sender, charities[organizationName], amount);
        require(success, "CharityPlatform: Transfer to charity failed");

        emit DonationReceived(msg.sender, charities[organizationName], amount, addressToken);
    }

    function donateETH(string calldata organizationName) external payable {
        isOrganizationRegistered(organizationName);

        isZeroAmount(msg.value);

        address payable charityWallet = payable(charities[organizationName]);

        (bool sent,) = charityWallet.call{value: msg.value}("");
        require(sent, "CharityPlatform: ETH transfer failed");

        emit DonationReceived(msg.sender, charityWallet, msg.value, address(0));
    }

    /* ======== INTERNAL ======== */

    /* ======== ADMIN ======== */

    function registerOrganization(string calldata name, address wallet) external onlyOwner {
        isZeroAddress(wallet);

        require(bytes(name).length > 2, "CharityPlatform: Organization name length must be more than 2 symbols");

        require(charities[name] == address(0), "CharityPlatform: Organization with such name already registered");

        charities[name] = wallet;

        emit CharityRegistered(wallet, name);
    }

    function deleteOrganization(string calldata name) external onlyOwner {
        isOrganizationRegistered(name);

        delete charities[name];
    }

    /* ======== VIEW ======== */

    function isOrganizationRegistered(string calldata name) public view returns (bool) {
        if (charities[name] == address(0)) {
            revert CharityOrganizationIsNotDefined(name);
        }

        return true;
    }

    function isZeroAddress(address addressCheck) public pure {
        if (addressCheck == address(0)) {
            revert ZeroAddress();
        }
    }

    function isZeroAmount(uint256 amount) public pure {
        if (amount == 0) {
            revert ZeroAmount();
        }
    }
}
