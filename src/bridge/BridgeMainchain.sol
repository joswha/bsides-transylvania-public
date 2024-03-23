// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import { IBridgeMainchain } from "./IBridgeMainchain.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { IERC721 } from "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract BridgeMainchain is IBridgeMainchain, Ownable {

    constructor() Ownable(msg.sender) { }

    DepositInfo[] private _depositInfos;

    /**
     * Deposit the NFT to send to the side chain.
     * @param mainchainERC721 Address of the main chain ERC721.
     * @param tokenId TokenId of the NFT.
     * @param sidechainId Id of the side chain.
     * @param sideTo Destination address of the side chain.
     */
    function deposit(
        address mainchainERC721,
        uint256 tokenId,
        uint256 sidechainId,
        address sideTo
    ) external {
        require(sideTo != address(0), "sideTo is zero address.");

        IERC721(mainchainERC721).transferFrom(
            msg.sender,
            address(this),
            tokenId
        );
        _depositInfos.push(
            DepositInfo(
                mainchainERC721, // mainchainERC721
                tokenId, // tokenId
                msg.sender, // mainFrom
                address(0) // mainTo
            ) 
        );

        emit DepositInitiated(
            _depositInfos.length - 1,
            mainchainERC721,
            tokenId,
            sidechainId,
            msg.sender,
            sideTo
        );
    }

    /**
     * Finalize the withdrawal by the Relayer
     * @param mainchainId Id of the main chain.
     * @param depositIndex Index of the DepositInfo.
     * @param sidechainId Id of the side chain.
     * @param withdrawalIndex Index of the WithdrawalInfo.
     * @param sideFrom Source address of the side chain.
     * @param mainTo Destination address of the main chain.
     */
    function finalizeWithdrawal(
        uint256 mainchainId,
        uint256 depositIndex,
        uint256 sidechainId,
        uint256 withdrawalIndex,
        address sideFrom,
        address mainTo
    ) external onlyOwner {
        require(mainTo != address(0), "mainTo is zero address.");

        DepositInfo storage mainInfo = _depositInfos[depositIndex];
        require(mainInfo.mainTo == address(0), "already withdraw");

        IERC721(mainInfo.mainchainERC721).safeTransferFrom(
            address(this),
            mainTo,
            mainInfo.tokenId
        );
    }
}
