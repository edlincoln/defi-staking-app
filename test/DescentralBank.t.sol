// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/RWD.sol";
import "../src/Token.sol";
import "../src/DecentralBank.sol";

contract DecentralBankTest is Test {
    
    address owner;
    address customer;
    uint256 constant public totalSupply = 1000000000000000000000000; // 1 million tokens

    Token token;
    RWD rwd;
    DecentralBank decentralBank;

    function setUp() public {
        owner = address(0x1234);
        customer = address(this);

        token = new Token(totalSupply);
        rwd = new RWD(totalSupply);
        decentralBank = new DecentralBank(rwd, token);
    }

    function toWei(uint256 amount) public pure returns (uint256) {
        return amount * 1 ether;
    }

    // Test "matches name successfully" for each contract
    function testContractNames() public {
        assertEq(token.name(), "ESL Token");
        assertEq(rwd.name(), "RWD ESL Token");
        assertEq(decentralBank.name(), "Decentral Bank");
    }

 
    function testYieldFarming() public {

        uint256 value = toWei(100);
        token.approve(address(decentralBank), toWei(10**20));
        
        rwd.approve(address(decentralBank), totalSupply);
        rwd.transfer(address(decentralBank), totalSupply);

        decentralBank.depositTokens(value);

        assertEq(token.balanceOf(address(decentralBank)), value);

        assertTrue(decentralBank.isStaking(customer));

        // test issuing tokens
        decentralBank.issueTokens();
        assertEq(rwd.balanceOf(address(this)), value);

        // Test unstaking tokens
        decentralBank.unstakeTokens();
        assertEq(token.balanceOf(address(this)), totalSupply);
        assertEq(token.balanceOf(address(decentralBank)), 0);

        assertFalse(decentralBank.isStaking(customer));
    }
}
