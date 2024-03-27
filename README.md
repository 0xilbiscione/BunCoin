# BunToken
Development of $BUN, an ERC20 token build on Base

## BunToken.sol
This smart contract, named BunToken, inherits from Ownable2Step and ERC20. Let’s break down its key features:

### Token Information:
- Name: `Bun Coin`
- Symbol: `BUN`
- Total supply: `1,000,000,000 $BUN` tokens

### Functionality:
- `burn(uint256 amount)`: Allows token holders to burn (destroy) a specified amount of their own tokens.
- `launch()`: Can only be called by the contract owner to mark the token as launched.
- `excludeFromLimits(address[] calldata accounts, bool value)`: Excludes specified accounts from certain limits.
- `setBots(address[] calldata accounts, bool value)`: Sets specified accounts as bots.
- `_beforeTokenTransfer(...)`: Internal function that checks various conditions before token transfers.

### Mappings:
- `isBot`: Maps addresses to a boolean indicating whether they are considered bots.
- `isExcludedFromLimits`: Maps addresses to a boolean indicating whether they are excluded from certain limits.

### Events:
- `Launch()`: Emitted when the token is launched.
- `ExcludeFromLimits(address indexed account, bool value)`: Emitted when an account is excluded from limits.
