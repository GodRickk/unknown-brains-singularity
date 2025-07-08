interface ICharityPlatform {
    event CharityRegistered(address indexed wallet, string name);

    event DonationReceived(address indexed donor, address indexed charity, uint256 amount, address token);

    error CharityOrganizationIsNotDefined(string name);

    error ZeroAddress();

    error ZeroAmount();
}
