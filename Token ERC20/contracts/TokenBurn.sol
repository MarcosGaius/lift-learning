// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MobTokenBurn is ERC20 {
  uint256 private _BURN_FEE_BP = 500;

  constructor(uint256 _initialSupply) ERC20("MobTokenBurn", "MOBB"){
    _mint(msg.sender, _initialSupply);
  }

  function transfer(address to, uint256 amount) public virtual override returns (bool) {
        require((amount/10000) * 10000 == amount, "Valor muito baixo.");
        address owner = _msgSender();
        uint256 burnAmount = amount * _BURN_FEE_BP / 10000;
        _transfer(owner, to, (amount - burnAmount));
        return true;
  }
}