// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {ERC20} from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {

    constructor(uint256 initSupply) ERC20("ESL Token", "ESL") {
        _mint(msg.sender, initSupply);
    }

    function mint(uint256 amount, address to) external {
        require(amount < 1 ether);
        _mint(to, amount);
    }
}

