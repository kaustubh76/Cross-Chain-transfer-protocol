// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

interface ICCTPEndpoint {
    function burnUSDC(
        address from,
        uint256 amount,
        bytes calldata destinationChain,
        bytes calldata destinationAddress
    ) external;

    function verifyMint(
        bytes calldata mintRequest
    ) external returns (bool success);
}
