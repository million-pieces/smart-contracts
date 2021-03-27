// SPDX-License-Identifier: Unlicense

pragma solidity ^0.6.12;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "./interfaces/IMillionPieces.sol";
import "./interfaces/IAuction.sol";


contract Auction is IAuction, Ownable {
  using SafeMath for uint256;

  uint256 public constant BATCH_PURCHASE_LIMIT = 25;
  uint256 public constant PRICE_FOR_SEGMENT = 0.1 ether;

  address payable public fund;
  IMillionPieces public millionPieces;

  event NewSinglePurchase(address purchaser, address receiver, uint256 tokenId, uint256 weiAmount);
  event NewBatchPurchase(address purchaser, address[] receivers, uint256[] tokenIds, uint256 ethSent);
  event SpecialSegmentCreated(address[] receivers, uint256[] tokenIds, uint256[] amountsPaid);

  constructor(
    address _millionPieces,
    address payable _fund
  ) public {
    fund = _fund;
    millionPieces = IMillionPieces(_millionPieces);
  }

  fallback () external payable { revert(); }
  receive () external payable { revert(); }

  //  --------------------
  //  PUBLIC
  //  --------------------

  function buySingle(address receiver, uint256 tokenId) external payable override {
    _buySingle(receiver, tokenId);
  }

  function buyMany(
    address[] calldata receivers,
    uint256[] calldata tokenIds
  ) external payable override {
    _buyMany(receivers, tokenIds);
  }

  //  --------------------
  //  INTERNAL
  //  -------------------

  function _buySingle(address receiver, uint256 tokenId) private {
    require(msg.value >= PRICE_FOR_SEGMENT, "_buySingle: Not enough ETH for purchase!");
    require(millionPieces.isValidWorldSegment(tokenId), "_buySingle: Invalid token ID");

    // Mint token to receiver
    _mintNft(receiver, tokenId);

    // Emit single segment purchase event
    emit NewSinglePurchase(msg.sender, receiver, tokenId, msg.value);

    // Send ETH to fund address
    _transferEth(msg.value);
  }

  function _buyMany(address[] memory receivers, uint256[] memory tokenIds) private {
    uint256 tokensCount = tokenIds.length;
    require(tokensCount > 0 && tokensCount <= BATCH_PURCHASE_LIMIT, "_buyMany: Arrays should bigger 0 and less then max limit!");
    require(tokensCount == receivers.length, "_buyMany: Arrays should be equal to each other!");
    require(msg.value >= tokensCount.mul(PRICE_FOR_SEGMENT), "_buyMany: Not enough ETH for purchase!");

    for (uint256 i = 0; i < tokensCount; i++) {
      // Mint token to receiver
      _mintNft(receivers[i], tokenIds[i]);
    }

    // Emit multi segments purchase event
    emit NewBatchPurchase(msg.sender, receivers, tokenIds, msg.value);

    // Send ETH to fund address
    _transferEth(msg.value);
  }

  /**
   * @notice Transfer amount of ETH to the fund address.
   */
  function _transferEth(uint256 amount) private {
    (bool success, ) = fund.call{value: amount}("");
    require(success, "_transferEth: Failed to transfer funds!");
  }

  /**
   * @notice Mint simple segment.
   */
  function _mintNft(address receiver, uint256 tokenId) private {
    millionPieces.safeMint(receiver, tokenId);
  }
}