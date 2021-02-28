// SPDX-License-Identifier: Unlicense

pragma solidity 0.6.6;


/**
 * @title IMillionPieces
 */
interface IMillionPieces {
    function safeMint(address to, uint256 tokenId) external;
    function safeMintBig(address to, uint256 tokenId) external;
    function exists(uint256 tokenId) external view returns (bool);
    function isSpecialSegment(uint256 tokenId) external view returns (bool);
    function isValidWorldSegment(uint256 tokenId) external view returns (bool);
}