// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import "../src/RWD.sol";
import "../src/Token.sol";
import "../src/DecentralBank.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract DecentralBankScript is Script {

    function setUp() public {}

    function run() public {
        
        vm.startBroadcast(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80);

        uint256 amount = 1000000000000000000000000;

        Token token = new Token(amount);
        RWD rwd = new RWD(amount);
        DecentralBank decentralBank = new DecentralBank(rwd, token);

        token.approve(address(decentralBank), amount);

        decentralBank.depositTokens(1 * 1 ether);

        vm.stopBroadcast();
    }
}
