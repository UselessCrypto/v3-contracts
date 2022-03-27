//SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

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

/**
 * @title Owner
 * @dev Set & change owner
 */
contract Ownable {

    address private owner;
    
    // event for EVM logging
    event OwnerSet(address indexed oldOwner, address indexed newOwner);
    
    // modifier to check if caller is owner
    modifier onlyOwner() {
        // If the first argument of 'require' evaluates to 'false', execution terminates and all
        // changes to the state and to Ether balances are reverted.
        // This used to consume all gas in old EVM versions, but not anymore.
        // It is often a good idea to use 'require' to check if functions are called correctly.
        // As a second argument, you can also provide an explanation about what went wrong.
        require(msg.sender == owner, "Caller is not owner");
        _;
    }
    
    /**
     * @dev Set contract deployer as owner
     */
    constructor() {
        owner = msg.sender; // 'msg.sender' is sender of current call, contract deployer for a constructor
        emit OwnerSet(address(0), owner);
    }

    /**
     * @dev Change owner
     * @param newOwner address of new owner
     */
    function changeOwner(address newOwner) public onlyOwner {
        emit OwnerSet(owner, newOwner);
        owner = newOwner;
    }

    /**
     * @dev Return owner address 
     * @return address of owner
     */
    function getOwner() external view returns (address) {
        return owner;
    }
}

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

contract Allocator is Ownable {

    // Receiver Data
    struct Receiver {
        bool isReceiver;           // True If Verified Receiver
        uint256 allocation;        // Useless To Allocate Per Block
        uint256 lastBlockReceived; // Last Block To Receive Tokens
        uint256 index;
    }
    mapping ( address => Receiver ) public receivers;
    address[] public allReceivers;

    // Total Allocation Points
    uint256 public totalAllocation;

    // USELESS Token
    address public USELESS;

    // Total Allocated
    uint256 public TOTAL_TOKENS_ALLOCATED;

    // Events
    event Allocated(address caller, address to, uint256 amount);
    event SetAllocation(address receiver, uint256 perBlockAllocation);
    event AddReceiver(address receiver, uint256 perBlockAllocation);
    event RemoveReceiver(address receiver);
    event PairedUSELESS(address USELESS);
    event SetEmissionRate(uint256 newRate);

    function allocate(address to) external returns (uint256) {
        require(
            receivers[msg.sender].isReceiver,
            'Only Receivers Can Call'
        );
        require(
            receivers[msg.sender].lastBlockReceived < block.number,
            'Same Block Entry'
        );
        require(
            receivers[msg.sender].allocation > 0,
            'Zero Allocation'
        );
        require(
            to != address(0),
            'Zero Destination'
        );

        // difference in blocks * tokens per block
        uint256 amount = amountToReceive(msg.sender);
        require(
            amount > 0,
            'Zero To Receive'
        );

        // track last block received
        receivers[msg.sender].lastBlockReceived = block.number;

        // increment total for tracking purposes
        TOTAL_TOKENS_ALLOCATED += amount;

        // send designated amount to the destination
        IERC20(USELESS).transfer(to, amount);
        emit Allocated(msg.sender, to, amount);
        return amount;
    }

    function amountToReceive(address receiver) public view returns (uint256) {
        return receivers[receiver].allocation * ( block.number - receivers[receiver].lastBlockReceived );
    }

    function setUSELESS(address _USELESS) external onlyOwner {
        require(USELESS == address(0) && _USELESS != address(0), 'Already Paired');
        USELESS = _USELESS;
        emit PairedUSELESS(_USELESS);
    }

    function setAllocation(address receiver, uint256 newAllocation) external onlyOwner {
        require(receivers[receiver].isReceiver, 'Not A Receiver');

        // update allocation
        totalAllocation = totalAllocation - receivers[receiver].allocation + newAllocation;
        receivers[receiver].allocation = newAllocation;

        emit SetAllocation(receiver, newAllocation);
    }

    function addReceiver(address receiver, uint256 tokensPerBlock) external onlyOwner {
        require(!receivers[receiver].isReceiver, 'Already Receiver');

        // increase current rate
        totalAllocation += tokensPerBlock;

        // add receiver data
        receivers[receiver].isReceiver = true;
        receivers[receiver].allocation = tokensPerBlock;
        receivers[receiver].lastBlockReceived = block.number;
        receivers[receiver].index = allReceivers.length;

        // push to all receiver list
        allReceivers.push(receiver);

        emit AddReceiver(receiver, tokensPerBlock);
    }

    function removeReceiver(address receiver) external onlyOwner {
        require(receivers[receiver].isReceiver, 'Not A Receiver');

        // subtract from current rate
        totalAllocation -= receivers[receiver].allocation;

        receivers[
            allReceivers[
                allReceivers.length -1
            ]
        ].index = receivers[receiver].index;

        allReceivers[
            receivers[receiver].index    
        ] = allReceivers[
            allReceivers.length - 1
        ];
        allReceivers.pop();

        // erase storage
        delete receivers[receiver];
        emit RemoveReceiver(receiver);
    }


}
