// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "./ICCTPEndpoint.sol";
import "cctp-foundry/lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract DestinationChainBridge {
    IERC20 public usdc;
    ICCTPEndpoint public cctpEndpoint;

    event USDCMinted(address indexed user, uint256 amount);

    constructor(address _usdc, address _cctpEndpoint) {
        usdc = IERC20(_usdc);
        cctpEndpoint = ICCTPEndpoint(_cctpEndpoint);
    }

    function mintUSDC(
        address user,
        uint256 amount,
        bytes calldata mintRequest
    ) external {
        // Verify Circle's burn proof
        bool verified = cctpEndpoint.verifyMint(mintRequest);
        require(verified, "Mint verification failed");

        // Mint USDC to the user
        usdc.transfer(user, amount);

        emit USDCMinted(user, amount);
    }
}
