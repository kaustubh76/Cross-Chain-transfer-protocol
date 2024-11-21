// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "cctp-foundry/lib/forge-std/src/Test.sol";
import "../src/MockERC20.sol";

contract MockERC20Test is Test {
    MockERC20 public usdc;
    address user = address(0x1);

    function setUp() public {
        usdc = new MockERC20("Mock USDC", "USDC", 6);
        usdc.mint(user, 1000 * 1e6); // Mint 1000 USDC to the user
    }

    function testMint() public {
        assertEq(usdc.balanceOf(user), 1000 * 1e6); // Ensure mint worked
    }

    function testTransfer() public {
        address recipient = address(0x2);

        vm.startPrank(user);
        usdc.transfer(recipient, 500 * 1e6); // Transfer 500 USDC
        vm.stopPrank();

        assertEq(usdc.balanceOf(user), 500 * 1e6);
        assertEq(usdc.balanceOf(recipient), 500 * 1e6);
    }

    function testBurn() public {
        vm.startPrank(user);
        usdc.burn(user, 500 * 1e6); // Burn 500 USDC
        vm.stopPrank();

        assertEq(usdc.balanceOf(user), 500 * 1e6);
    }
}
