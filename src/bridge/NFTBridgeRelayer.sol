// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import { IBridgeMainchain } from "./IBridgeMainchain.sol";
import { IBridgeSidechain } from "./IBridgeSidechain.sol";
import { ECDSA } from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract NFTBridgeRelayer  {

    address public mainchainBridge;
    address public sidechainBridge;

    /**
     * @param _mainchainBridge Address of the mainchain bridge.
     * @param _sidechainBridge Address of the sidechain bridge.
     */
    constructor(
        address _mainchainBridge,
        address _sidechainBridge
    ) {
        mainchainBridge = _mainchainBridge;
        sidechainBridge = _sidechainBridge;
    }

    function finalizeWithdrawal(
        uint256 mainchainId,
        uint256 depositIndex,
        uint256 sidechainId,
        uint256 withdrawalIndex,
        address sideFrom,
        address mainTo,
        uint64 expiration,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external {

        bytes32 _hash = keccak256(
            abi.encodePacked(
                mainchainId,
                depositIndex,
                sidechainId,
                withdrawalIndex,
                sideFrom,
                mainTo
            )
        );
        require(
            ECDSA.recover(_hash, v, r, s) == sideFrom,
            "Invalid signatures"
        );

        IBridgeMainchain(mainchainBridge).finalizeWithdrawal(
            mainchainId,
            depositIndex,
            sidechainId,
            withdrawalIndex,
            sideFrom,
            mainTo
        );
    }

    function createSidechainERC721(
        uint256 sidechainId,
        uint256 mainchainId,
        address mainERC721,
        string memory name,
        string memory symbol
    ) external {
        IBridgeSidechain(sidechainBridge).createSidechainERC721(
            sidechainId,
            mainchainId,
            mainERC721,
            name,
            symbol
        );
    }

    function finalizeDeposit(
        uint256 sidechainId,
        uint256 mainchainId,
        uint256 depositIndex,
        address mainERC721,
        uint256 tokenId,
        address mainFrom,
        address sideTo,
        uint64 expiration,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external {
        bytes32 _hash = keccak256(
            abi.encodePacked(
                sidechainId,
                mainchainId,
                depositIndex,
                mainERC721,
                tokenId,
                mainFrom,
                sideTo
            )
        );

        require(
            expiration > block.timestamp,
            "Signature expired"
        );

        require(
            ECDSA.recover(_hash, v, r, s) == mainFrom,
            "Invalid signatures"
        );

        IBridgeSidechain(sidechainBridge).finalizeDeposit(
            sidechainId,
            mainchainId,
            depositIndex,
            mainERC721,
            tokenId,
            mainFrom,
            sideTo
        );
    }
}
