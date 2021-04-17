// SPDX-License-Identifier: Unlicense

pragma solidity ^0.6.12;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "./interfaces/IMillionPieces.sol";


/**
 * @title MillionPieces
 */
contract MillionPieces is ERC721, IMillionPieces, AccessControl {
    using SafeMath for uint256;

    string[] internal _availableWorlds;

    uint256 public constant NFTS_PER_WORLD = 10000;
    uint256 public constant SPECIAL_SEGMENTS_COUNT = 20;

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant PRIVILEGED_MINTER_ROLE = keccak256("PRIVILEGED_MINTER_ROLE");
    bytes32 public constant DEVELOPER_ROLE = keccak256("DEVELOPER_ROLE");

    event NewWorldCreated(uint256 id, string name);
    event TokenUriChanged(uint256 token, string uri);
    event BaseUriChanged(string uri);

    constructor (address developer) public ERC721("MillionPieces", "MP") {
        require(developer != address(0), "MillionPieces: Developer address can not be empty!");

        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(DEVELOPER_ROLE, developer);

        emit NewWorldCreated(_availableWorlds.length, "The World");

        _availableWorlds.push("The World");
    }

    //  --------------------
    //  GETTERS
    //  --------------------

    function exists(uint256 tokenId) public view override returns (bool) {
        return _exists(tokenId);
    }

    function isValidWorldSegment(uint256 tokenId) public view override returns (bool) {
        return tokenId > 0 && NFTS_PER_WORLD.mul(_availableWorlds.length) >= tokenId;
    }

    function isSpecialSegment(uint256 tokenId) public pure override returns (bool) {
        return (tokenId % NFTS_PER_WORLD) < SPECIAL_SEGMENTS_COUNT;
    }

    function getWorld(uint256 id) public view override returns (string memory) {
        return _availableWorlds[id];
    }

    //  --------------------
    //  SETTERS PROTECTED
    //  --------------------

    function createWorld(string calldata name) external override {
        require(hasRole(DEVELOPER_ROLE, msg.sender), "createWorld: Unauthorized access!");

        emit NewWorldCreated(_availableWorlds.length, name);

        _availableWorlds.push(name);
    }

    function setTokenURI(uint256 tokenId, string calldata uri) external override {
        require(hasRole(DEVELOPER_ROLE, msg.sender), "setTokenURI: Unauthorized access!");

        _setTokenURI(tokenId, uri);

        emit TokenUriChanged(tokenId, uri);
    }

    function setBaseURI(string calldata baseURI) external override {
        require(hasRole(DEVELOPER_ROLE, msg.sender), "setBaseURI: Unauthorized access!");

        _setBaseURI(baseURI);

        emit BaseUriChanged(baseURI);
    }

    function safeMint(address to, uint256 tokenId) external override {
        require(hasRole(MINTER_ROLE, msg.sender), "safeMint: Unauthorized access!");
        require(isValidWorldSegment(tokenId), "safeMint: This token unavailable!");
        require(!isSpecialSegment(tokenId), "safeMint: The special segments can not be minted with this method!");

        string memory uri = _generateTokenUri(tokenId);

        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    function safeMintSpecial(address to, uint256 tokenId) external override {
        require(hasRole(PRIVILEGED_MINTER_ROLE, msg.sender), "safeMintSpecial: Unauthorized access!");
        require(isValidWorldSegment(tokenId), "safeMintSpecial: This token unavailable!");
        require(isSpecialSegment(tokenId), "safeMintSpecial: The simple segments can not be minted with this method!");

        string memory uri = _generateTokenUri(tokenId);

        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    //  --------------------
    //  INTERNAL
    //  --------------------

    function _generateTokenUri(uint256 tokenId) internal view returns (string memory) {
      return _uriStringConcat(
          baseURI(),
          _uintToString(tokenId.div(NFTS_PER_WORLD)),
          '/',
          _uintToString(tokenId)
      );
    }

    function _uriStringConcat(string memory _a, string memory _b, string memory _c, string memory _d)
        internal
        pure
        returns (string memory)
    {
        return string(abi.encodePacked(_a, _b, _c, _d));
    }

    function _uintToString(uint256 _i) internal pure returns (string memory _uintAsString) {
        uint256 number = _i;
        if (number == 0) {
            return "0";
        }

        uint256 j = number;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }

        bytes memory bstr = new bytes(len);
        uint256 k = len - 1;
        while (number != 0) {
            bstr[k--] = byte(uint8(48 + number % 10));
            number /= 10;
        }

        return string(bstr);
    }
}