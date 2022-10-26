// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MobTokenPayable is ERC20 {
  mapping(address => uint256) private _balances;
  address CONTRACT_OWNER;

  constructor(uint256 _initialSupply) ERC20("MobTokenPayable", "MOBP"){
    _mint(msg.sender, _initialSupply);
    CONTRACT_OWNER = msg.sender;
  }
  
  function buyToken() payable public virtual returns (bool) {
    require(msg.sender != CONTRACT_OWNER, "Use mint function instead.");
    
    uint256 _amount = msg.value;

    require(balanceOf(CONTRACT_OWNER) >= _amount, "Buying amount is too high.");

    _transfer(CONTRACT_OWNER, msg.sender, _amount);

    return true;
  }

}