// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MobToken is ERC20 {
  constructor(uint256 _initialSupply) ERC20("MobToken", "MOB"){
      _mint(msg.sender, _initialSupply);
  }
}