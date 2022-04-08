//SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

interface IERC20 {

    function totalSupply() external view returns (uint256);
    
    function symbol() external view returns(string memory);
    
    function name() external view returns(string memory);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);
    
    /**
     * @dev Returns the number of decimal places
     */
    function decimals() external view returns (uint8);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
    external
    payable
    returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
    external
    returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
    external
    returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
    external
    payable
    returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

interface IUniswapV2Factory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}

interface IUseless {
    function burn(uint amount) external;
}

interface IFurnaceDB {
    function pullLiquidityRange() external view returns (uint256);
    function buyAndBurnRange() external view returns (uint256);
    function reverseSALRange() external view returns (uint256);
}

/**
 * 
 * ONE Sent to this contract will be used to automatically manage the Useless Liquidity Pool
 *
 */
contract Furnace {
    
    using SafeMath for uint256;
  
    /**  Useless Stats  **/
    address immutable public _token;
    address immutable public _tokenLP;
  
    /** address of wrapped ONE **/ 
    address immutable private ONE;
    
    // database
    IFurnaceDB furnaceDB;
  
    /** ONE Thresholds **/
    uint256 constant public automateThreshold = 5 * 10**16;
    uint256 constant max_ONE_in_call = 100000 * 10**18;
  
    /** Pancakeswap Router **/
    IUniswapV2Router02 constant router = IUniswapV2Router02(0x32253394e1C9E33C0dA3ddD54cDEff07E457A687);
  
    /** Flash-Loan Prevention **/
    uint256 lastBlockAutomated;
    
    /** ONE -> Token **/
    address[] private ONEToToken;

    constructor(address _useless, address _uselessLP, address _furnaceDB) {
        // Instantiate Token and LP
        _token = _useless;
        _tokenLP = _uselessLP;
        // WETH
        ONE = router.WETH();
        // ONE -> Token
        ONEToToken = new address[](2);
        ONEToToken[0] = router.WETH();
        ONEToToken[1] = _useless;

        // furnace database
        furnaceDB = IFurnaceDB(_furnaceDB);
    }
  
    /** Automate Function */
    function BURN_IT_DOWN_BABY() external {
        require(lastBlockAutomated < block.number, 'Same Block Entry');
        lastBlockAutomated = block.number;
        automate();
    }
    
    function getRanges() public view returns (uint256 pL, uint256 bbr, uint256 rsal) {
        pL = furnaceDB.pullLiquidityRange();
        bbr = furnaceDB.buyAndBurnRange();
        rsal = furnaceDB.reverseSALRange();
    }

    /** Automate Function */
    function automate() private {
        // check useless standing
        checkUselessStanding();
        // determine the health of the lp
        uint256 dif = determineLPHealth();
        // check cases
        dif = clamp(dif, 1, 10000);
        
        (uint256 pullLiquidityRange, uint256 buyAndBurnRange, uint256 reverseSALRange) = getRanges();
    
        if (dif <= pullLiquidityRange) {
            uint256 percent = uint256(10000).div(dif);
            pullLiquidity(percent);
        } else if (dif <= buyAndBurnRange) {
            buyAndBurn();
        } else if (dif <= reverseSALRange) {
            reverseSwapAndLiquify();
        } else {
            uint256 tokenBal = IERC20(_token).balanceOf(address(this));
            if (liquidityThresholdReached(tokenBal)) {
                pairLiquidity(tokenBal);
            } else {
                reverseSwapAndLiquify();
            }
        }
    }

    /**
     * Buys USELESS Tokens and burns them
     */ 
    function buyAndBurn() private {
        // keep ONE in range
        uint256 ONEToUse = address(this).balance > max_ONE_in_call ? max_ONE_in_call : address(this).balance;
        // buy and burn it
        router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: ONEToUse}(
            0, 
            ONEToToken,
            address(this), // store
            block.timestamp.add(30)
        );
        // received from swap
        uint256 bal = IERC20(_token).balanceOf(address(this));
        if (bal > 0) {
            _burn(bal);
        }
        
        // tell blockchain
        emit BuyAndBurn(ONEToUse);
    }
  
   /**
    * Uses ONE in Contract to Purchase Useless, pairs with remaining ONE and adds to Liquidity Pool
    * Reversing The Effects Of SwapAndLiquify
    * Price Positive - LP Neutral Operation
    */
    function reverseSwapAndLiquify() private {
        // ONE Balance before the swap
        uint256 initialBalance = address(this).balance > max_ONE_in_call ? max_ONE_in_call : address(this).balance;
        // USELESS Balance before the Swap
        uint256 contractBalance = IERC20(_token).balanceOf(address(this));
        // Swap 50% of the ONE in Contract for USELESS Tokens
        uint256 transferAMT = initialBalance.div(2);
        // Swap ONE for USELESS
        router.swapExactETHForTokens{value: transferAMT}(
            0, // accept any amount of USELESS
            ONEToToken,
            address(this), // Store in Contract
            block.timestamp.add(30)
        );
        // how many USELESS Tokens were received
        uint256 diff = IERC20(_token).balanceOf(address(this)).sub(contractBalance);
        // add liquidity to Pancakeswap
        addLiquidity(diff, transferAMT);
        emit ReverseSwapAndLiquify(diff, transferAMT);
    }
   
    /**
     * Pairs ONE and USELESS in the contract and adds to liquidity if we are above thresholds 
     */
    function pairLiquidity(uint256 uselessInContract) private {
        // amount of ONE in the pool
        uint256 ONELP = IERC20(ONE).balanceOf(_tokenLP);
        // make sure we have tokens in LP
        ONELP = ONELP == 0 ? address(_tokenLP).balance : ONELP;
        // how much ONE do we need to pair with our useless
        uint256 ONEBal = getTokenInToken(_token, ONE, uselessInContract);
        //if there isn't enough ONE in contract
        if (address(this).balance < ONEBal) {
            // recalculate with ONE we have
            uint256 nUseless = uselessInContract.mul(address(this).balance).div(ONEBal);
            addLiquidity(nUseless, address(this).balance);
            emit LiquidityPairAdded(nUseless, address(this).balance);
        } else {
            // pair liquidity as is 
            addLiquidity(uselessInContract, ONEBal);
            emit LiquidityPairAdded(uselessInContract, ONEBal);
        }
    }
    
    /** Checks Number of Tokens in LP */
    function checkUselessStanding() private {
        uint256 threshold = getCirculatingSupply().div(10**4);
        uint256 uselessBalance = IERC20(_token).balanceOf(address(this));
        if (uselessBalance >= threshold) {
            // burn 1/4 of balance
            _burn(uselessBalance.div(2));
        }
    }
    
    function _burn(uint256 portion) internal {
        IUseless(_token).burn(portion);
    }
   
    /** Returns the price of tokenOne in tokenTwo according to Pancakeswap */
    function getTokenInToken(address tokenOne, address tokenTwo, uint256 amtTokenOne) public view returns (uint256){
        address[] memory path = new address[](2);
        path[0] = tokenOne;
        path[1] = tokenTwo;
        return router.getAmountsOut(amtTokenOne, path)[1];
    } 
    
    /**
     * Adds USELESS and ONE to the USELESS/ONE Liquidity Pool
     */ 
    function addLiquidity(uint256 uselessAmount, uint256 ONEAmount) private {
       
        // approve router to move tokens
        IERC20(_token).approve(address(router), uselessAmount);
        // add the liquidity
        router.addLiquidityETH{value: ONEAmount}(
            _token,
            uselessAmount,
            0,
            0,
            address(this),
            block.timestamp.add(30)
        );
    }

    /**
     * Removes Liquidity from the pool and stores the ONE and USELESS in the contract
     */
    function pullLiquidity(uint256 percentLiquidity) private returns (bool){
       // Percent of our LP Tokens
       uint256 pLiquidity = IERC20(_tokenLP).balanceOf(address(this)).mul(percentLiquidity).div(10**2);
       // Approve Router 
       IERC20(_tokenLP).approve(address(router), pLiquidity);
       // remove the liquidity
       router.removeLiquidityETHSupportingFeeOnTransferTokens(
            _token,
            pLiquidity,
            0,
            0,
            address(this),
            block.timestamp.add(30)
        );
        
        emit LiquidityPulled(percentLiquidity, pLiquidity);
        return true;
    }
    
    /**
     * Determines the Health of the LP
     * returns the percentage of the Circulating Supply that is in the LP
     */ 
    function determineLPHealth() public view returns(uint256) {
        // Find the balance of USELESS in the liquidity pool
        uint256 lpBalance = IERC20(_token).balanceOf(_tokenLP).mul(2);
        // lpHealth = Supply / LP Balance
        return lpBalance == 0 ? 2 : getCirculatingSupply().mul(100).div(lpBalance);
    }
    
    /** Whether or not the Pair Liquidity Threshold has been reached */
    function liquidityThresholdReached(uint256 bal) private view returns (bool) {
        return bal >= getCirculatingSupply().div(10**7);
    }
  
    /** Returns the Circulating Supply of Token */
    function getCirculatingSupply() private view returns(uint256) {
        return IERC20(_token).totalSupply();
    }
  
    /** Amount of LP Tokens in this contract */ 
    function getLPTokenBalance() external view returns (uint256) {
        return IERC20(_tokenLP).balanceOf(address(this));
    }
  
    /** Percentage of LP Tokens In Contract */
    function getPercentageOfLPTokensOwned() external view returns (uint256) {
        return uint256(10**18).mul(IERC20(_tokenLP).balanceOf(address(this))).div(IERC20(_tokenLP).totalSupply());
    }
      
    /** Clamps a variable between a min and a max */
    function clamp(uint256 variable, uint256 min, uint256 max) private pure returns (uint256){
        if (variable <= min) {
            return min;
        } else if (variable >= max) {
            return max;
        } else {
            return variable;
        }
    }
  
    // EVENTS 
    event BuyAndBurn(uint256 amountONEUsed);
    event ReverseSwapAndLiquify(uint256 uselessAmount,uint256 ONEAmount);
    event LiquidityPairAdded(uint256 uselessAmount,uint256 ONEAmount);
    event LiquidityPulled(uint256 percentOfLiquidity, uint256 numLPTokens);

    // Receive ONE
    receive() external payable { }

}
