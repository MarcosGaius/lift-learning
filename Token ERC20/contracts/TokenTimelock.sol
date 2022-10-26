// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MobTokenTimelock is ERC20 {
  uint256 _MAX_LOCK_TIME = 1672531200;
  address _contractOwner;

  constructor(uint256 _initialSupply) ERC20("MobTokenTimelock", "MOBLOCK"){
    _mint(msg.sender, _initialSupply);
    _contractOwner = msg.sender;
  }

  function transfer(address to, uint256 amount) public virtual override returns (bool) {
    if(msg.sender != _contractOwner){
      require(block.timestamp > _MAX_LOCK_TIME, "Transfers avaiable only in 2023.");
    }
    address owner = _msgSender();
    _transfer(owner, to, amount);
    return true;
  }
}
