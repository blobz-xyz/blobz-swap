// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DummyUSDC is ERC20 {
    uint8 private _customDecimals;

    constructor() ERC20("DummyUSDC", "DUMMYUSDC") {
        _customDecimals = 6;
        _mint(msg.sender, 1_000_000 * (10 ** uint256(_customDecimals)));
    }

    function decimals() public view virtual override returns (uint8) {
        return _customDecimals;
    }
}