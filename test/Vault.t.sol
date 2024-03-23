// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {Vault} from "../src/vault/Vault.sol";
import {IERC20, DummyToken} from "../src/vault/DummyToken.sol";

contract VaultTest is Test {
    Vault private vault;
    DummyToken private dummyToken;

    address[] private users = [address(13), address(17)];

    function setUp() public {
        dummyToken = new DummyToken();
        vault = new Vault(address(dummyToken));

        for (uint256 i = 0; i < users.length; i++) {
            dummyToken.mint(users[i], 10000 * (10 ** 18));
            vm.prank(users[i]);
            dummyToken.approve(address(vault), type(uint256).max);
        }
    }

    function test_attack() public {

    }
}
