// SPDX-License-Identifier: Unlicensed

pragma solidity 0.8.22;

import "@openzeppelin/contracts@4.9.6/utils/math/SafeMath.sol";
import "@openzeppelin/contracts@4.9.6/access/Ownable2Step.sol";
import "@openzeppelin/contracts@4.9.6/token/ERC20/utils/SafeERC20.sol";

contract BunAirdropper is Ownable2Step {
    using Address for address;
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    receive() external payable {}

    fallback() external payable {}

    function bulkTransferETH(
        address payable[] memory recipients,
        uint256[] memory values
    ) public payable onlyOwner {
        for (uint256 i = 0; i < recipients.length; i++) {
            (bool success, ) = recipients[i].call{value: values[i]}("");
            require(success, "BunAirdropper: User transfer failed");
        }
    }

    function bulkTransferToken(
        IERC20 token,
        address[] memory recipients,
        uint256[] memory values
    ) public onlyOwner {
        uint256 total = 0;
        for (uint256 i = 0; i < recipients.length; i++) total += values[i];
        token.safeTransferFrom(_msgSender(), address(this), total);
        for (uint256 i = 0; i < recipients.length; i++)
            token.safeTransfer(recipients[i], values[i]);
    }

    function bulkTransferTokenSimple(
        IERC20 token,
        address[] memory recipients,
        uint256[] memory values
    ) public onlyOwner {
        for (uint256 i = 0; i < recipients.length; i++)
            token.safeTransferFrom(_msgSender(), recipients[i], values[i]);
    }

    function withdrawStuckTokens(address tkn) public onlyOwner {
        uint256 amount;
        if (tkn == address(0)) {
            bool success;
            amount = address(this).balance;
            (success, ) = address(_msgSender()).call{value: amount}("");
        } else {
            require(
                IERC20(tkn).balanceOf(address(this)) > 0,
                "BunAirdropper: No tokens"
            );
            amount = IERC20(tkn).balanceOf(address(this));
            IERC20(tkn).safeTransfer(_msgSender(), amount);
        }
    }
}
