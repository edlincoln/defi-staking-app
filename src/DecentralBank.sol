// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import './RWD.sol';
import './Token.sol';
import "forge-std/console.sol";

/**
 * @title DecentralBank
 * @dev A decentralized bank smart contract for staking and issuing rewards in a custom token (RWD).
 */
contract DecentralBank {
    string public name = "Decentral Bank";
    address public owner;
    Token public token;
    RWD public rwd;

    address[] public stakers;

    mapping(address => uint) public stakingBalance;
    mapping(address => bool) public hasStaked;
    mapping(address => bool) public isStaking;

    /**
     * @dev Constructor to initialize the DecentralBank contract with RWD and Token instances.
     * @param _rwd The RWD token instance.
     * @param _token The Token instance.
     */
    constructor(RWD _rwd, Token _token) {
        rwd = _rwd;
        token = _token;
        owner = msg.sender;
    }

    /**
     * @dev Stake tokens into the DecentralBank and start earning rewards.
     * @param _amount The amount of tokens to stake.
     */
    function depositTokens(uint _amount)  public {
        require(_amount > 0, 'amount cannot be 0');
        
        token.transferFrom(msg.sender, address(this), _amount);       
        stakingBalance[msg.sender] += _amount;
        if (!hasStaked[msg.sender]) {
            stakers.push(msg.sender);
        }

        isStaking[msg.sender] = true;
        hasStaked[msg.sender] = true;
    }

    /**
     * @dev Unstake tokens and withdraw from the staking pool.
     */
    function unstakeTokens() public {
        uint balance = stakingBalance[msg.sender];
        require(balance > 0, 'staking balance cannot be less than zero');

        token.transfer(msg.sender, balance);
        stakingBalance[msg.sender] = 0;
        isStaking[msg.sender] = false;
    }

    /**
     * @dev Issue RWD tokens as rewards to all stakers, callable only by the owner.
     */
    function issueTokens() public {
        require(msg.sender == owner, 'caller must be the owner');
        for (uint i = 0; i < stakers.length; i++) {
            address recipient = stakers[i];
            uint balance = stakingBalance[recipient]; // / 9;
            if (balance > 0) {
                rwd.transfer(recipient, balance);
            }
        }
    }
}