// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "forge-std/Test.sol";
import "../contracts/MockCCTPEndpoint.sol";

contract MockCCTPEndpointTest is Test {
    MockCCTPEndpoint public cctpEndpoint;

    function setUp() public {
        cctpEndpoint = new MockCCTPEndpoint();
    }

    function testBurnUSDC() public {
        // Simulate a burn operation
        bytes memory destinationChain = "Sepolia";
        bytes memory destinationAddress = abi.encodePacked(address(0x1));

        vm.expectEmit(true, true, true, true);
        emit MockCCTPEndpoint.BurnUSDC(address(this), 100 * 1e6, destinationChain, destinationAddress);

        cctpEndpoint.burnUSDC(address(this), 100 * 1e6, destinationChain, destinationAddress);
    }

    function testVerifyMint() public {
        // Simulate a mint verification
        uint256 amount = 100 * 1e6;
        bytes memory mintRequest = abi.encodePacked(address(0x1), amount);

        vm.expectEmit(true, true, true, true);
        emit MockCCTPEndpoint.MintVerification(mintRequest);

        bool success = cctpEndpoint.verifyMint(mintRequest);
        assertTrue(success);
    }
}
