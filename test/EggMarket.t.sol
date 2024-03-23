pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {EggMarket} from "../src/market/EggMarket.sol";
import {Egg} from "../src/market/Egg.sol";
import "forge-std/console.sol";

contract EggMarketTest is Test {
    EggMarket public eggMarket;
    Egg public egg;
    Egg public rottenEgg;

    address[] private users = [address(13), address(17)];

    function setUp() public {
        egg = new Egg();
        rottenEgg = new Egg();
        eggMarket = new EggMarket(address(egg));
        
        // Prank as users[0] and mint some eggs.
        vm.startPrank(users[0]);
        egg.mintToSender(); 
        egg.mintToSender();
        egg.mintToSender();
        vm.stopPrank();

        // Prank as users[1] and mint some eggs.
        vm.startPrank(users[1]);
        egg.mintToSender();
        egg.mintToSender();
        egg.mintToSender();
        // Mint some rotten eggs too:
        rottenEgg.mintToSender();
        rottenEgg.mintToSender();
        rottenEgg.mintToSender();
        vm.stopPrank();
    }

    function test_attack() public {
    }

}