// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {IERC20} from "./DummyToken.sol";

contract Vault {
    IERC20 public immutable token;

    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;

    constructor(address _token) {
        token = IERC20(_token);
    }

    /**
        @dev Function to mint new shares.

        @param _to The address to mint the shares to.
        @param _shares The amount of shares to mint.
     */
    function _mint(address _to, uint256 _shares) private {
        totalSupply += _shares;
        balanceOf[_to] += _shares;
    }

    /**
        @dev Function to burn shares.

        @param _from The address to burn the shares from.
        @param _shares The amount of shares to burn.
     */
    function _burn(address _from, uint256 _shares) private {
        totalSupply -= _shares;
        balanceOf[_from] -= _shares;
    }

    /**
        @dev Function to deposit tokens into the vault.

        @param amount The amount of tokens to deposit.
     */
    function deposit(uint256 amount) external {
        uint256 shares;
        if (totalSupply == 0) {
            shares = amount;
        } else {
            shares = (amount * totalSupply) / token.balanceOf(address(this));
        }

        _mint(msg.sender, shares);
        token.transferFrom(msg.sender, address(this), amount);
    }

    /**
        @dev Function to withdraw tokens from the vault.

        @param shares The amount of shares to withdraw.
     */
    function withdraw(uint256 shares) external returns (uint256) {
        uint256 amount = (shares * token.balanceOf(address(this))) / totalSupply;
        _burn(msg.sender, shares);
        token.transfer(msg.sender, amount);
        return amount;
    }

    /**
        @dev Function to preview the amount of tokens that can be redeemed.

        @param shares The amount of shares to preview the redeem for.
     */
    function previewRedeem(uint256 shares) external view returns (uint256) {
        if (totalSupply == 0) {
            return 0;
        }
        return (shares * token.balanceOf(address(this))) / totalSupply;
    }
}