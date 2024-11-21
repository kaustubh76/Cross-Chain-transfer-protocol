// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "forge-std/Test.sol";
import "../contracts/SourceChainBridge.sol";
import "../contracts/MockCCTPEndpoint.sol";
import "../src/MockERC20.sol";

contract SourceChainBridgeTest is Test {
    SourceChainBridge public bridge;
    MockERC20 public usdc;
    MockCCTPEndpoint public cctpEndpoint;

    address user = address(0x1);

    function setUp() public {
        // Deploy Mock USDC and mint tokens to the user
        usdc = new MockERC20("Mock USDC", "USDC", 6);
        usdc.mint(user, 1000 * 1e6); // Mint 1000 USDC (with 6 decimals)

        // Deploy mock CCTP endpoint and the bridge contract
        cctpEndpoint = new MockCCTPEndpoint();
        bridge = new SourceChainBridge(address(usdc), address(cctpEndpoint));
    }

    function testBurnUSDC() public {
        uint256 burnAmount = 100 * 1e6; // 100 USDC (6 decimals)

        // Simulate the user approving and calling burnUSDC
        vm.startPrank(user);
        usdc.approve(address(bridge), burnAmount);
        bridge.burnUSDC(burnAmount, "Sepolia", abi.encodePacked(user));
        vm.stopPrank();

        // Assertions
        assertEq(usdc.balanceOf(user), 900 * 1e6); // User's balance should decrease
        assertEq(usdc.balanceOf(address(cctpEndpoint)), 0); // Tokens burned by endpoint
    }
}
