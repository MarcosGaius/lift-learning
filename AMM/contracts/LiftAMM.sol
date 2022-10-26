// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract LiftAMM is ERC20 { 
    uint256 public totalPoolSupply;
    mapping(address => uint256) public balance; 

    address public tokenA;
    address public tokenB;

    uint256 SWAP_FEE = 3;
    uint256 totalTokenAFee;
    uint256 totalTokenBFee;

    constructor(address _tokenA, address _tokenB) ERC20("LiquidityTokenAMM", "ALT") {  
        tokenA = _tokenA;
        tokenB = _tokenB;
    }

    modifier ensureDeadline(uint256 deadline) {
        require(block.timestamp <= deadline, "Deadline expired.");
        _;
    }

    // Raiz quadrada: https://github.com/Uniswap/v2-core/blob/master/contracts/libraries/Math.sol
    function squareRoot(uint256 y) internal pure returns (uint256 z) {
        if (y > 3) {
            z = y;
            uint256 x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }    

    function addLiquidity(uint256 amountA, uint256 amountB, uint256 deadline) ensureDeadline(deadline) external returns (uint256 liquidity) {       
        IERC20(tokenA).transferFrom(msg.sender, address(this), amountA);
        IERC20(tokenB).transferFrom(msg.sender, address(this), amountB);

        uint256 balanceA = IERC20(tokenA).balanceOf(address(this));
        uint256 balanceB = IERC20(tokenB).balanceOf(address(this));

        require(totalPoolSupply * amountA / balanceA == totalPoolSupply * amountB / balanceB, "Wrong proportion between asset A and B");

        liquidity = squareRoot(amountA * amountB);
        totalPoolSupply += liquidity;
        balance[msg.sender] += liquidity;
        _mint(msg.sender, liquidity);
    }

    function removeLiquidity(uint256 liquidity, uint256 deadline) external ensureDeadline(deadline) returns (uint256 amountA, uint256 amountB) {   
        require(balance[msg.sender] >= liquidity, "Not enough liquidity for this, amount too big"); 
        uint256 balanceA = IERC20(tokenA).balanceOf(address(this));
        uint256 balanceB = IERC20(tokenB).balanceOf(address(this));         

        uint divisor = totalPoolSupply / liquidity;
        amountA = balanceA / divisor;
        amountB = balanceB / divisor;

        totalPoolSupply -= liquidity;
        balance[msg.sender] -= liquidity;  

        IERC20(tokenA).transfer(msg.sender, amountA);
        IERC20(tokenB).transfer(msg.sender, amountB); 
        _burn(msg.sender, liquidity);
    }

    function swap(address tokenIn, uint256 amountIn, uint256 minAmountOut) external returns (uint256 amountOut) {
        uint256 newBalance;
        require(tokenIn == tokenA || tokenIn == tokenB, "TokenIn not in pool");        

        uint256 balanceA = IERC20(tokenA).balanceOf(address(this)); // X
        uint256 balanceB = IERC20(tokenB).balanceOf(address(this)); // Y

        uint256 k = balanceA * balanceB; // K = X * Y   

        if (tokenIn == tokenA) {
            uint256 fee = (amountIn * SWAP_FEE) / 1000;
            IERC20(tokenA).transferFrom(msg.sender, address(this), amountIn + fee);
            totalTokenAFee += fee;
            newBalance = k / (balanceA + amountIn);
            amountOut = balanceB - newBalance;            
            require(amountOut >= minAmountOut, "Swap output amount is less than the intended by user.");
            IERC20(tokenB).transfer(msg.sender, amountOut);
        }
        else {
            uint256 fee = (amountIn * SWAP_FEE) / 1000;
            IERC20(tokenB).transferFrom(msg.sender, address(this), amountIn + fee);
            totalTokenBFee += fee;
            newBalance = k / (balanceB + amountIn);
            amountOut = balanceA - newBalance;
            require(amountOut >= minAmountOut, "Swap output amount is less than the intended by user.");
            IERC20(tokenA).transfer(msg.sender, amountOut);
        }      
    }
}
