pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {Bank} from "../src/bank/Bank.sol";
import {BankHack} from "../src/attack/BankHack.sol";
import "forge-std/console.sol";

contract BankTest is Test {
    Bank public bank;
    // BankHack public bankHack;

    function setUp() public {
        bank = new Bank();
    
        // Fund the bank to simulate user deposits
        vm.deal(address(bank), 100 ether);
    }

    function test_attack() public {

    }

}