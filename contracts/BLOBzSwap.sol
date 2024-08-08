// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract BLOBzSwap is Ownable {

    IERC20 public tokenA;                   // $BLOBz 18 decimals
    IERC20 public tokenB;                   // $USDC   6 decimals
    uint256 public exchangeRate = 10**18;   // 1M (6) + decimal diff (12)
    bool public isActive = true;

    constructor(address initialOwner) Ownable(initialOwner) {
        tokenA = IERC20(0x000000000000000000000000000000000000dEaD); // $BLOBz *** TODO ***
        tokenB = IERC20(0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913); // $USDC
    }

    // manage contract (owner)
    function setTokenA(address newToken) external onlyOwner {
        tokenA = IERC20(newToken);
    }
    function setTokenB(address newToken) external onlyOwner {
        tokenB = IERC20(newToken);
    }
    function setExchangeRate(uint256 newRate) external onlyOwner {
        exchangeRate = newRate;
    }
    function toggleActive() external onlyOwner {
        isActive = !isActive;
    }
    function withdraw(address tokenAddress, uint256 amount) external onlyOwner {
        require(IERC20(tokenAddress).transfer(msg.sender, amount), "token transfer failed");
    }

    // buy $BLOBZ with $USDC
    function buy(uint256 amountB) external {
        require(isActive, "swap is not active");
        uint256 amountA = amountB * exchangeRate;

        // check contract $BLOBz
        require(tokenA.balanceOf(address(this)) >= amountA, "not enough $BLOBz");

        // transfer $USDC => contract
        require(tokenB.balanceOf(msg.sender) >= amountB, "not enough $USDC");
        require(tokenB.transferFrom(msg.sender, address(this), amountB), "$USDC transfer failed");

        // transfer $BLOBz => sender
        require(tokenA.transfer(msg.sender, amountA), "$BLOBz transfer failed");
    }

}