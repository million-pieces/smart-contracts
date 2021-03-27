// SPDX-License-Identifier: Unlicense

pragma solidity ^0.6.12;


/**
 * @title IMillionPieces
 */
interface IMillionPieces {
    function safeMint(address to, uint256 tokenId) external;
    function safeMintSpecial(address to, uint256 tokenId) external;
    function createWorld(string calldata name) external;
    function setTokenURI(uint256 tokenId, string calldata uri) external;
    function setBaseURI(string calldata baseURI) external;
    function exists(uint256 tokenId) external view returns (bool);
    function isSpecialSegment(uint256 tokenId) external pure returns (bool);
    function isValidWorldSegment(uint256 tokenId) external view returns (bool);
    function getWorld(uint256 id) external view returns (string memory);
}