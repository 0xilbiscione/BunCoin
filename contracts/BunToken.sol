// SPDX-License-Identifier: Unlicensed

pragma solidity 0.8.22;

import "@openzeppelin/contracts@4.9.6/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts@4.9.6/access/Ownable2Step.sol";

contract BunToken is Ownable2Step, ERC20 {
    bool public launched;

    mapping(address => bool) public isBot;
    mapping(address => bool) public isExcludedFromLimits;

    event Launch();
    event ExcludeFromLimits(address indexed account, bool value);

    constructor(address _owner) ERC20("Bun Coin", "BUN") {
        address sender = _msgSender();

        _excludeFromLimits(sender, true);
        _excludeFromLimits(_owner, true);
        _excludeFromLimits(address(this), true);
        _excludeFromLimits(0x3d4e44Eb1374240CE5F1B871ab261CD16335B76a, true); // Uniswap V3 QuoterV2

        _mint(_owner, 1_000_000_000 ether);
    }

    function burn(uint256 amount) public {
        _burn(_msgSender(), amount);
    }

    function launch() external onlyOwner {
        require(!launched, "BunToken: Already launched.");
        launched = true;
        emit Launch();
    }

    function excludeFromLimits(address[] calldata accounts, bool value)
        external
        onlyOwner
    {
        for (uint256 i = 0; i < accounts.length; i++) {
            _excludeFromLimits(accounts[i], value);
        }
    }

    function setBots(address[] calldata accounts, bool value)
        external
        onlyOwner
    {
        for (uint256 i = 0; i < accounts.length; i++) {
            isBot[accounts[i]] = value;
        }
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual override {
        amount = amount; // silence unused variable warning
        address sender = _msgSender();
        require(!isBot[from], "BunToken: bot detected");
        require(sender == from || !isBot[sender], "BunToken: bot detected");
        require(
            tx.origin == from || tx.origin == sender || !isBot[tx.origin],
            "BunToken: bot detected"
        );
        require(
            launched || isExcludedFromLimits[from] || isExcludedFromLimits[to],
            "BunToken: not launched."
        );
    }

    function _excludeFromLimits(address account, bool value) internal virtual {
        isExcludedFromLimits[account] = value;
        emit ExcludeFromLimits(account, value);
    }
}
