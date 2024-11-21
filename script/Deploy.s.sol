// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "cctp-foundry/lib/forge-std/src/script.sol";
import "../contracts/SourceChainBridge.sol";
import "../contracts/DestinationChainBridge.sol";
import "../contracts/MockCCTPEndpoint.sol";

contract Deploy is Script {
    function run() external {
        uint256 deployerKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerKey);

        address usdc = 0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238; // Replace with actual USDC address
        MockCCTPEndpoint mockEndpoint = new MockCCTPEndpoint();

        SourceChainBridge sourceBridge = new SourceChainBridge(usdc, address(mockEndpoint));
        DestinationChainBridge destinationBridge = new DestinationChainBridge(usdc, address(mockEndpoint));

        console.log("SourceChainBridge deployed at:", address(sourceBridge));
        console.log("DestinationChainBridge deployed at:", address(destinationBridge));

        vm.stopBroadcast();
    }
}
