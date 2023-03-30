// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.19;

import "erc721a/contracts/extensions/ERC721ABurnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

contract GreenRoomToken is ERC721A, ERC721ABurnable, Ownable, Pausable {

    uint96 public mintValue = 0.1 ether;

    constructor(string memory name_, string memory symbol_) ERC721A(name_, symbol_) {
        _pause();
    }

    function exists(uint256 tokenId) public view returns (bool) {
        return _exists(tokenId);
    }

    function privateMint(uint256 quantity) onlyOwner external {
        _safeMint(msg.sender, quantity);
    }

    function mint(uint256 quantity) whenNotPaused payable external {
        require(msg.value >= mintValue * quantity);
        _safeMint(msg.sender, quantity);
    }

    function withdraw() onlyOwner external {
        (bool sent, bytes memory data) = msg.sender.call{value: address(this).balance}("");
        require(sent, "Failed to send Ether");
    }

    function setPause() onlyOwner external {
        _pause();
    }

    function setUnpause() onlyOwner external {
        _unpause();
    }

    function setMintValue(uint96 _value) onlyOwner external {
        mintValue = (_value);
    }

    function getOwnershipAt(uint256 index) public view returns (TokenOwnership memory) {
        return _ownershipAt(index);
    }

    function totalMinted() public view returns (uint256) {
        return _totalMinted();
    }

    function totalBurned() public view returns (uint256) {
        return _totalBurned();
    }

    function numberBurned(address owner) public view returns (uint256) {
        return _numberBurned(owner);
    }

    function contractBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
