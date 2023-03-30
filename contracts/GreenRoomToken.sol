// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.19;

import "erc721a/contracts/extensions/ERC721ABurnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract GreenRoomToken is ERC721A, ERC721ABurnable, Ownable {

    uint96 public mintValue;
    bool private paused = true;
    
    /// @dev Uri of metada. Set after deploy. 
    string private uri;

    constructor(string memory name_, string memory symbol_) ERC721A(name_, symbol_) {
    }

    function exists(uint256 tokenId) public view returns (bool) {
        return _exists(tokenId);
    }

    function privateMint(uint256 quantity) onlyOwner external {
        _safeMint(msg.sender, quantity);
    }

    function mint(uint256 quantity) payable external {
        require(!paused, "It is paused");
        require(msg.value >= mintValue * quantity, "Not enough funds");
        _safeMint(msg.sender, quantity);
    }

    function withdraw() onlyOwner external {
        (bool sent, bytes memory data) = msg.sender.call{value: address(this).balance}("");
        require(sent, "Failed to send Ether");
    }

    function setPause() onlyOwner external {
        paused = true;
    }

    function setUnpause() onlyOwner external {
        paused = false;
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

    /// @dev Set base uri. OnlyOwner can call it.
    function setBaseURI(string memory _value) external onlyOwner {
        uri = _value;
    }

    /// @dev Returns base uri
    function _baseURI() internal view virtual override returns (string memory) {
        return uri;
    }
}
