// SPDX-License-Identifier: Unlicense

pragma solidity 0.6.6;


/**
 * @title IMillionPieces
 */
interface IMillionPieces {
    function exists(uint256 tokenId) external view returns (bool);
    function safeMint(address to, uint256 tokenId) external;
}