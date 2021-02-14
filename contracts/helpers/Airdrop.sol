//SPDX-License-Identifier: Unlicense

pragma solidity 0.6.6;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";


/**
 * @title ERC20 Airdrop dapp smart contract
 */
contract Airdrop {
  using SafeERC20 for IERC20;

  /**
   * @dev doAirdrop is the main method for distribution
   * @param token airdropped token address (PIECE address)
   * @param addresses address[] addresses to airdrop
   * @param amounts address[] values for each address
   */
  function doAirdrop(IERC20 token, address[] calldata addresses, uint256 [] calldata amounts) external returns (uint256) {
    require(addresses.length > 0 && addresses.length == amounts.length, "doAirdrop: invalid input arrays!");

    uint256 i = 0;
    while (i < addresses.length) {
      token.safeTransferFrom(msg.sender, addresses[i], amounts[i]);
      i += 1;
    }

    return i;
  }

  function emergencyExit(address payable receiver) external {
    receiver.transfer(address(this).balance);
  }

  function emergencyExit(IERC20 token, address receiver) external {
    token.safeTransfer(receiver, token.balanceOf(address(this)));
  }
}