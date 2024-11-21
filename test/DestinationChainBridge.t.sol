// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "cctp-foundry/lib/forge-std/src/Test.sol";
import "../contracts/DestinationChainBridge.sol";
import "../contracts/MockCCTPEndpoint.sol";
import "../src/MockERC20.sol";

contract DestinationChainBridgeTest is Test {
    DestinationChainBridge public bridge;
    MockERC20 public usdc;
    MockCCTPEndpoint public cctpEndpoint;

    address user = address(0x1);

    function setUp() public {
        // Deploy Mock USDC and mock CCTP endpoint
        usdc = new MockERC20("Mock USDC", "USDC", 6);
        cctpEndpoint = new MockCCTPEndpoint();

        // Deploy the bridge contract
        bridge = new DestinationChainBridge(address(usdc), address(cctpEndpoint));

        // Mint tokens to the bridge for distribution
        usdc.mint(address(bridge), 1000 * 1e6);
    }

    function testMintUSDC() public {
        uint256 mintAmount = 100 * 1e6; // 100 USDC (6 decimals)

        // Call mintUSDC with a valid mintRequest
        bytes memory mintRequest = abi.encodePacked(user, mintAmount);
        bridge.mintUSDC(user, mintAmount, mintRequest);

        // Assertions
        assertEq(usdc.balanceOf(user), 100 * 1e6); // User should receive the minted tokens
    }
}
