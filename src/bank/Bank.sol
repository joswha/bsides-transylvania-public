// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;


contract Bank {

    // mapping that handles the balances of the users.
    mapping(address => uint256) public balances;

    /**
        @dev Deposit ETH into the contract.
    */
    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    /**
        @dev Withdraw ETH from the contract.
    */
    function withdraw() public {
        uint256 bal = balances[msg.sender];
        require(bal > 0);

        (bool success,) = msg.sender.call{value: bal}("");
        require(success, "err: transfer failed");

        balances[msg.sender] = 0;
    }

    /**
        @dev Get the balance of the contract.
    */
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}