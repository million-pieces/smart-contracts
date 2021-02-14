// SPDX-License-Identifier: Unlicense

pragma solidity 0.6.6;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "./interfaces/IMillionPieces.sol";


contract Auction is Ownable {
    using SafeMath for uint256;

    uint256 public constant NFTS_PER_WORLD = 10000;
    uint256 public constant BIG_SEGMENTS_COUNT = 20;
    uint256 public constant BATCH_PURCHASE_LIMIT = 25;
    uint256 public constant PRICE_FOR_SEGMENT = 0.1 ether;

    address payable public fund;
    IMillionPieces public millionPieces;

    event NewSinglePurchase(address purchaser, address receiver, uint256 tokenId, uint256 weiAmount);
    event NewBulkPurchase(address purchaser, address[] receivers, uint256[] tokenIds, uint256 ethSent);
    event BigSegmentCreated(address[] receivers, uint256[] tokenIds, uint256[] amountsPaid);

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
    //  PUBLIC PROTECTED
    //  --------------------

    function mingBig(
      address[] calldata receivers,
      uint256[] calldata tokenIds,
      uint256[] calldata amountsPaid
    ) external onlyOwner {
      _mintBig(receivers, tokenIds, amountsPaid);
    }

    function changeFundAddress(address payable newFund) external onlyOwner {
      fund = newFund;
    }

    //  --------------------
    //  PUBLIC
    //  --------------------

    function buyMany(
      address[] calldata receivers,
      uint256[] calldata tokenIds
    ) external payable {
      _buyMany(receivers, tokenIds);
    }

    function buySingle(address receiver, uint256 tokenId) external payable {
      _buySingle(receiver, tokenId);
    }

    //  --------------------
    //  INTERNAL
    //  -------------------

    function _mintBig(address[] memory receivers, uint256[] memory tokenIds, uint256[] memory amountsPaid) private {
      uint256 tokensCount = tokenIds.length;
      require(tokensCount > 0, "_mintBig: Arrays should bigger 0!");
      require(tokensCount == receivers.length && receivers.length == amountsPaid.length, "_mintBig: Arrays should be equal to each other!");

      for (uint256 i = 0; i < tokensCount; i++) {
        require(_isValidBigId(tokenIds[i]), "mingBigSegments: Invalid token ID");

        // Mint token to receiver
        _mintNft(receivers[i], tokenIds[i]);
      }

      // Emit big segments purchase event
      emit BigSegmentCreated(receivers, tokenIds, amountsPaid);
    }

    function _buySingle(address receiver, uint256 tokenId) private {
      require(msg.value >= PRICE_FOR_SEGMENT, "_buySingle: Not enough ETH for purchase!");
      require(_isValidId(tokenId), "_buySingle: Invalid token ID");

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
        require(_isValidId(tokenIds[i]), "_buyMany: Invalid token ID");

        // Mint token to receiver
        _mintNft(receivers[i], tokenIds[i]);
      }

      // Emit multi segments purchase event
      emit NewBulkPurchase(msg.sender, receivers, tokenIds, msg.value);

      // Send ETH to fund address
      _transferEth(msg.value);
    }

    function _isValidId(uint256 tokenId) private pure returns (bool) {
      return tokenId > BIG_SEGMENTS_COUNT && tokenId <= NFTS_PER_WORLD;
    }

    function _isValidBigId(uint256 tokenId) private pure returns (bool) {
      return tokenId > 0 && tokenId <= BIG_SEGMENTS_COUNT;
    }

    /**
     * @notice Transfer provided amount ETH to fund address.
     */
    function _transferEth(uint256 amount) private {
      fund.transfer(amount);
    }

    /**
     * @notice Transfer provided amount ETH to fund address.
     */
    function _mintNft(address receiver, uint256 tokenId) private {
      millionPieces.safeMint(receiver, tokenId);
    }
}