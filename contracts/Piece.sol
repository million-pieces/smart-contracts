//SPDX-License-Identifier: Unlicense

pragma solidity ^0.6.12;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract Piece is ERC20 {
  uint256 constant TOTAL_SUPPLY = 1000000 ether; // 1 mln tokens

  constructor(address receiver) public ERC20("PIECE", "PIECE") {
    require(receiver != address(0), "Piece: Receiver can not be an empty address!");

    _mint(receiver,  TOTAL_SUPPLY);
  }

  function burn(uint256 amount) public {
    _burn(msg.sender, amount);
  }
}