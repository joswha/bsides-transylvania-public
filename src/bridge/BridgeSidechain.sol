// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import { IBridgeSidechain } from "./IBridgeSidechain.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { ERC721Token } from "./ERC721Token.sol";

contract BridgeSidechain is IBridgeSidechain, Ownable(msg.sender) {

    mapping(uint256 => mapping(address => address)) private _erc721Map;
    mapping(uint256 => mapping(uint256 => bool)) private _depositIndexes;
    mapping(address => mapping(uint256 => uint256)) private _depositIndexMap;
    WithdrawalInfo[] private _withdrawalInfos;

    /**
     * Returns the Side chain ERC721.
     * @param mainchainId Id of the main chain.
     */
    function getSidechainERC721(uint256 mainchainId, address mainchainERC721)
        public
        view
        returns (address)
    {
        return _erc721Map[mainchainId][mainchainERC721];
    }

    /**
     * Create new ERC721 corresponding to the main chain
     * @param sidechainId Id of the sidechain.
     * @param mainchainId Id of the mainchain.
     * @param mainchainERC721 Address of the mainchain ERC721.
     * @param name Name of the NFT
     * @param symbol Symbol of the NFT
     */
    function createSidechainERC721(
        uint256 sidechainId,
        uint256 mainchainId,
        address mainchainERC721,
        string memory name,
        string memory symbol
    ) external onlyOwner {
        ERC721Token erc721 = new ERC721Token(name, symbol);
        _erc721Map[mainchainId][mainchainERC721] = address(erc721);   

    }

    /**
     * Finalize the deposit by the Relayer
     * @param sidechainId Id of the sidechain.
     * @param mainchainId Id of the mainchain.
     * @param depositIndex Index of the DepositInfo.
     * @param mainchainERC721 Address of the mainchain ERC721.
     * @param tokenId TokenId of the NFT.
     * @param mainFrom Source address of the mainchain.
     * @param sideTo Destination address of the sidechain.
     */
    function finalizeDeposit(
        uint256 sidechainId,
        uint256 mainchainId,
        uint256 depositIndex,
        address mainchainERC721,
        uint256 tokenId,
        address mainFrom,
        address sideTo
    ) external onlyOwner {
        require(sidechainId == block.chainid, "Invalid side chain id");

        address sidechainERC721 = getSidechainERC721(
            mainchainId,
            mainchainERC721
        );
        if (sidechainERC721 == address(0)) {
            emit DepositFailed(
                mainchainId,
                depositIndex,
                mainchainERC721,
                sidechainERC721,
                tokenId,
                mainFrom,
                sideTo
            );
            return;
        }

        require(
            !_depositIndexes[mainchainId][depositIndex],
            "Already deposited"
        );

        try ERC721Token(sidechainERC721).mint(sideTo, tokenId) {
            _depositIndexes[mainchainId][depositIndex] = true;
            _depositIndexMap[sidechainERC721][tokenId] = depositIndex;

        } catch {
            emit DepositFailed(
                mainchainId,
                depositIndex,
                mainchainERC721,
                sidechainERC721,
                tokenId,
                mainFrom,
                sideTo
            );
        }
    }

    /**
     * Withdraw the NFT to send to the mainchain.
     * @param sidechainERC721 Address of the sidechain ERC721.
     * @param tokenId TokenId of the NFT.
     * @param mainTo Destination address of the mainchain.
     */
    function withdraw(
        address sidechainERC721,
        uint256 tokenId,
        address mainTo
    ) external {
        // ... some withdrawing logic.
    }
}
