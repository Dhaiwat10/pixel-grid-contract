pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

// import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

//learn more: https://docs.openzeppelin.com/contracts/3.x/erc721

// GET LISTED ON OPENSEA: https://testnets.opensea.io/get-listed/step-two

contract PixelGrid is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    uint256 public constant MINTING_COST = 0.0001 ether;

    constructor() ERC721("PixelGrid", "PXL") {}

    function _baseURI() internal view virtual override returns (string memory) {
        return "ipfs://";
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        // DO SOMETHING
        return super.tokenURI(tokenId);
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
}
