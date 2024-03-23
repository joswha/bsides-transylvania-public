pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";

import "forge-std/Vm.sol";

import {BridgeMainchain} from "../src/bridge/BridgeMainchain.sol";
import {BridgeSidechain} from "../src/bridge/BridgeSidechain.sol";
import {NFTBridgeRelayer} from "../src/bridge/NFTBridgeRelayer.sol";
import {ERC721Token} from "../src/bridge/ERC721Token.sol";
import "forge-std/console.sol";

contract BridgeTest is Test {
    
    ERC721Token public erc721Token;
    NFTBridgeRelayer public bridge;
    BridgeMainchain public mainchain;
    BridgeSidechain public sidechain;

    address[] private users = [address(13), address(17)];
    Vm.Wallet user13 = vm.createWallet("user13");
    Vm.Wallet user17 = vm.createWallet("user17");


    function setUp() public {
        erc721Token = new ERC721Token("token", "TKN");
        sidechain = new BridgeSidechain();
        mainchain = new BridgeMainchain();

        bridge = new NFTBridgeRelayer(
            address(mainchain), 
            address(sidechain)
        );

        mainchain.transferOwnership(address(bridge));
        sidechain.transferOwnership(address(bridge));
    }

    function test_attack() public {

    }

}