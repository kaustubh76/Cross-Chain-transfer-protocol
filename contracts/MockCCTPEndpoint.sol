// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "./ICCTPEndpoint.sol";

contract MockCCTPEndpoint is ICCTPEndpoint {
    event BurnUSDC(address indexed from, uint256 amount, bytes destinationChain, bytes destinationAddress);
    event MintVerification(bytes mintRequest);

    function burnUSDC(
        address from,
        uint256 amount,
        bytes calldata destinationChain,
        bytes calldata destinationAddress
    ) external override {
        emit BurnUSDC(from, amount, destinationChain, destinationAddress);
    }

    function verifyMint(
        bytes calldata mintRequest
    ) external override returns (bool success) {
        emit MintVerification(mintRequest);
        return true; // Always succeed for mock
    }
}
