// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface IBridgeMainchain {

    event DepositInitiated(
        uint256 indexed depositIndex,
        address indexed mainchainERC721,
        uint256 indexed tokenId,
        uint256 sidechainId,
        address mainFrom,
        address sideTo
    );

    event DepositRejected(uint256 indexed depositIndex);

    event WithdrawalFinalized(
        uint256 indexed depositIndex,
        uint256 indexed sidechainId,
        uint256 indexed withdrawalIndex,
        address mainchainERC721,
        address sideFrom,
        address mainTo
    );

    event WithdrawalFailed(
        uint256 indexed depositIndex,
        uint256 indexed sidechainId,
        uint256 indexed withdrawalIndex,
        address mainchainERC721,
        address sideFrom,
        address mainTo
    );

    struct DepositInfo {
        address mainchainERC721;
        uint256 tokenId;
        address mainFrom;
        address mainTo;
    }

    function deposit(
        address mainchainERC721,
        uint256 tokenId,
        uint256 sidechainId,
        address sideTo
    ) external;

    function finalizeWithdrawal(
        uint256 mainchainId,
        uint256 depositIndex,
        uint256 sidechainId,
        uint256 withdrawalIndex,
        address sideFrom,
        address mainTo
    ) external;
}
