pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

// import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./ERC4907.sol";

//learn more: https://docs.openzeppelin.com/contracts/3.x/erc721

// GET LISTED ON OPENSEA: https://testnets.opensea.io/get-listed/step-two

contract PixelGrid is ERC4907, ERC721Enumerable, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    uint256 public constant MINTING_COST = 0.0001 ether;

    mapping(uint256 => string) public _hashMap;

    constructor() ERC4907("PixelGrid", "PXL") {}

    function _baseURI() internal view virtual override returns (string memory) {
        return "ipfs://";
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        return string(abi.encodePacked(_baseURI(), _hashMap[tokenId]));
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override(ERC4907, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC4907, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function mintItem(address to, string memory _tokenURI)
        public
        payable
        returns (uint256)
    {
        require(msg.value >= MINTING_COST, "Insufficient ETH sent");
        _tokenIds.increment();

        uint256 id = _tokenIds.current();
        _mint(to, id);
        _setTokenURI(id, _tokenURI);

        return id;
    }

    function changeTokenURI(uint256 tokenId, string memory _tokenURI)
        public
        onlyOwner
        returns (bool)
    {
        _setTokenURI(tokenId, _tokenURI);
        return true;
    }

    function _setTokenURI(uint256 tokenId, string memory _tokenURI)
        internal
        returns (bool)
    {
        _hashMap[tokenId] = _tokenURI;
        return true;
    }
}
