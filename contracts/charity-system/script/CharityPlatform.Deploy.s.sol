// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {Script} from "forge-std/Script.sol";
import {CharityPlatform} from "../../src/CharityPlatform.sol";
import {console} from "forge-std/console.sol";

contract CharityPlatformDeploy is Script {
    uint256 privateKey = vm.envUint("PRIVATE_KEY");
    address owner = 0xB98BC23f1EdDb754d01DBc7B62B28039eC9A0cD9;

    function run() public {
        vm.createSelectFork(vm.envString("ARBITRUM_MAINNET_RPC_URL"));
        _deploy();
    }

    function _deploy() internal {
        vm.startBroadcast(privateKey);

        CharityPlatform charityPlatform = new CharityPlatform(owner);

        console.log("CharityPlatform deployed on address: ", address(charityPlatform));
        // console.log("ProxyFee owner: ", proxyFee.owner());
        // console.log("ProxyFee WETH: ", proxyFee.WETH());
        // console.log("ProxyFee feeReceiver: ", proxyFee.getFeeReceiver());
        // console.log("ProxyFee targetRouter: ", proxyFee.getTargetRouter());

        vm.stopBroadcast();
    }
}
