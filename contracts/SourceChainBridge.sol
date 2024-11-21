// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "./ICCTPEndpoint.sol";
import "cctp-foundry/lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract SourceChainBridge {
    IERC20 public usdc;
    ICCTPEndpoint public cctpEndpoint;

    event USDCBurned(address indexed user, uint256 amount, bytes destinationChain, bytes destinationAddress);

    constructor(address _usdc, address _cctpEndpoint) {
        usdc = IERC20(_usdc);
        cctpEndpoint = ICCTPEndpoint(_cctpEndpoint);
    }

    function burnUSDC(
        uint256 amount,
        bytes calldata destinationChain,
        bytes calldata destinationAddress
    ) external {
        require(usdc.transferFrom(msg.sender, address(this), amount), "USDC transfer failed");

        // Approve CCTP Endpoint to burn the tokens
        usdc.approve(address(cctpEndpoint), amount);

        // Call Circle's burn API
        cctpEndpoint.burnUSDC(msg.sender, amount, destinationChain, destinationAddress);

        emit USDCBurned(msg.sender, amount, destinationChain, destinationAddress);
    }
}
