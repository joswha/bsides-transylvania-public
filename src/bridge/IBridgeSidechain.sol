// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface IBridgeSidechain {

    event DepositFailed(
        uint256 indexed mainchainId,
        uint256 indexed depositIndex,
        address mainchainERC721,
        address sidechainERC721,
        uint256 tokenId,
        address mainFrom,
        address sideTo
    );

    event WithdrawalInitiated(
        uint256 indexed withdrawalIndex,
        uint256 indexed mainchainId,
        uint256 indexed depositIndex,
        address mainchainERC721,
        address sidechainERC721,
        uint256 tokenId,
        address sideFrom,
        address mainTo
    );

    event WithdrawalRejected(
        uint256 indexed withdrawalIndex,
        uint256 indexed mainchainId,
        uint256 indexed depositIndex
    );

    struct WithdrawalInfo {
        address sidechainERC721;
        uint256 tokenId;
        address sideFrom;
        bool rejected;
    }

    function createSidechainERC721(
        uint256 sidechainId,
        uint256 mainchainId,
        address mainchainERC721,
        string memory name,
        string memory symbol
    ) external;

    function finalizeDeposit(
        uint256 sidechainId,
        uint256 mainchainId,
        uint256 depositIndex,
        address mainchainERC721,
        uint256 tokenId,
        address mainFrom,
        address sideTo
    ) external;

    function withdraw(
        address sidechainERC721,
        uint256 tokenId,
        address mainTo
    ) external;
}
