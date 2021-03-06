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

interface IDistributor {
    function setShare(address shareholder, uint256 amount) external;
}
/**
    Useless V3 Contract
    Author: DeFi Mark
    
    Visit https://uselesscrypto.com
 */
contract Useless is IERC20, Ownable {

    using SafeMath for uint256;

    // token data
    string constant _name = "Useless";
    string constant _symbol = "USE";
    uint8 constant _decimals = 18;

    // Useless starting supply
    uint256 _totalSupply = 10**9 * 10**18;
    
    // balances
    mapping (address => uint256) _balances;
    mapping (address => mapping (address => uint256)) _allowances;
    
    // Taxation on transfers
    uint256 public buyFee             = 30;
    uint256 public sellFee            = 30;
    uint256 public transferFee        = 30;
    uint256 public constant TAX_DENOM = 1000;

    // Reward Distributor
    IDistributor distributor;

    // Useless Swapper
    address public UselessSwapper;

    // permissions
    struct Permissions {
        bool isIngressFeeExempt;
        uint256 ingressExemptIndex;
        bool isEgressFeeExempt;
        uint256 egressExemptIndex;
        bool rewardsExempt;
        bool isLiquidityPool;
    }
    mapping ( address => Permissions ) public permissions;

    // ingress and egress exemption arrays for transparency
    address[] public ingressExemptContracts;
    address[] public egressExemptContracts;

    // Fee Recipients
    address public sellFeeRecipient;
    address public buyFeeRecipient;
    address public transferFeeRecipient;

    // events
    event SetBuyFeeRecipient(address recipient);
    event SetSellFeeRecipient(address recipient);
    event SetTransferFeeRecipient(address recipient);
    event DistributorUpgraded(address newDistributor);
    event SetUselessSwapper(address newUselessSwapper);
    event SetRewardsExempt(address account, bool isExempt);
    event SetEgressExemption(address account, bool isEgressExempt);
    event SetIngressExemption(address account, bool isIngressFeeExempt);
    event SetAutomatedMarketMaker(address account, bool isMarketMaker);
    event SetFees(uint256 buyFee, uint256 sellFee, uint256 transferFee);

    constructor(address distributor_) {
        // dividends distributor
        distributor = IDistributor(distributor_);
        
        // initial supply allocation
        _balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    function totalSupply() external view override returns (uint256) { return _totalSupply; }
    function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
    function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
    
    function name() public pure override returns (string memory) {
        return _name;
    }

    function symbol() public pure override returns (string memory) {
        return _symbol;
    }

    function decimals() public pure override returns (uint8) {
        return _decimals;
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }
  
    /** Transfer Function */
    function transfer(address recipient, uint256 amount) external override returns (bool) {
        return _transferFrom(msg.sender, recipient, amount);
    }

    /** Transfer Function */
    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
        _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, 'Insufficient Allowance');
        return _transferFrom(sender, recipient, amount);
    }

    function burn(uint256 amount) external {
        require(
            balanceOf(msg.sender) >= amount && amount > 0,
            'Insufficient Balance'
        );
        _burn(msg.sender, amount);
    }

    function burnFrom(address account, uint amount) external {
        require(
            balanceOf(account) >= amount && amount > 0,
            'Insufficient Balance'
        );
        require(
            account != address(0),
            'Zero Address'
        );
        _allowances[account][msg.sender] = _allowances[account][msg.sender].sub(amount, 'Insufficient Allowance');
        _burn(account, amount);
    }
    
    /** Internal Transfer */
    function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
        require(
            recipient != address(0),
            'Zero Recipient'
        );
        require(
            amount > 0,
            'Zero Amount'
        );
        require(
            amount <= balanceOf(sender),
            'Insufficient Balance'
        );
        
        // decrement sender balance
        _balances[sender] = _balances[sender].sub(amount);

        // fee for transaction
        (uint256 fee, address feeRecipient) = getTax(sender, recipient, amount);

        if (fee > 0 && feeRecipient != address(0)) {
            // allocate fee
            _balances[feeRecipient] = _balances[feeRecipient].add(fee);
            emit Transfer(sender, feeRecipient, fee);
            // set share if non exempt
            if (!permissions[feeRecipient].rewardsExempt) {
                distributor.setShare(feeRecipient, balanceOf(feeRecipient));
            }
        }

        // give amount to recipient
        uint256 sendAmount = amount.sub(fee);
        _balances[recipient] = _balances[recipient].add(sendAmount);

        // set distributor state 
        if (!permissions[sender].rewardsExempt) {
            distributor.setShare(sender, balanceOf(sender));
        }
        if (!permissions[recipient].rewardsExempt) {
            distributor.setShare(recipient, balanceOf(recipient));
        }

        emit Transfer(sender, recipient, sendAmount);
        return true;
    }

    function withdraw(address token) external onlyOwner {
        IERC20(token).transfer(msg.sender, IERC20(token).balanceOf(address(this)));
    }

    function withdrawONE() external onlyOwner {
        (bool s,) = payable(msg.sender).call{value: address(this).balance}("");
        require(s);
    }

    function setBuyFeeRecipient(address recipient) external onlyOwner {
        require(recipient != address(0), 'Zero Address');
        buyFeeRecipient = recipient;
        setRewardsExempt(recipient, true);
        DisableEgressTaxation(recipient);
        DisableIngressTaxation(recipient);
        emit SetBuyFeeRecipient(recipient);
    }

    function setTransferFeeRecipient(address recipient) external onlyOwner {
        require(recipient != address(0), 'Zero Address');
        transferFeeRecipient = recipient;
        setRewardsExempt(recipient, true);
        DisableEgressTaxation(recipient);
        DisableIngressTaxation(recipient);
        emit SetTransferFeeRecipient(recipient);
    }

    function setSellFeeRecipient(address recipient) external onlyOwner {
        require(recipient != address(0), 'Zero Address');
        sellFeeRecipient = recipient;
        setRewardsExempt(recipient, true);
        DisableEgressTaxation(recipient);
        DisableIngressTaxation(recipient);
        emit SetSellFeeRecipient(recipient);
    }

    function upgradeDistributor(address newDistributor) external onlyOwner {
        require(newDistributor != address(0), 'Zero Address');
        distributor = IDistributor(newDistributor);
        emit DistributorUpgraded(newDistributor);
    }

    function setUselessSwapper(address newUselessSwapper) external onlyOwner {
        require(newUselessSwapper != address(0), 'Zero Address');
        UselessSwapper = newUselessSwapper;
        setRewardsExempt(newUselessSwapper, true);
        DisableEgressTaxation(newUselessSwapper);
        DisableIngressTaxation(newUselessSwapper);
        emit SetUselessSwapper(newUselessSwapper);
    }

    function registerAutomatedMarketMakerPair(address liquidityPool) external onlyOwner {
        require(liquidityPool != address(0), 'Zero Address');
        require(!permissions[liquidityPool].isLiquidityPool, 'Already An AMM');
        permissions[liquidityPool].isLiquidityPool = true;
        setRewardsExempt(liquidityPool, true);
        emit SetAutomatedMarketMaker(liquidityPool, true);
    }

    function unRegisterAutomatedMarketMakerPair(address liquidityPool) external onlyOwner {
        require(liquidityPool != address(0), 'Zero Address');
        require(permissions[liquidityPool].isLiquidityPool, 'Not An AMM');
        permissions[liquidityPool].isLiquidityPool = false;
        setRewardsExempt(liquidityPool, false);
        emit SetAutomatedMarketMaker(liquidityPool, false);
    }

    function setFees(uint _buyFee, uint _sellFee, uint _transferFee) external onlyOwner {
        require(
            buyFee <= TAX_DENOM.div(10),
            'Buy Fee Too High'
        );
        require(
            buyFee <= TAX_DENOM.div(10),
            'Sell Fee Too High'
        );
        require(
            buyFee <= TAX_DENOM.div(10),
            'Transfer Fee Too High'
        );

        buyFee = _buyFee;
        sellFee = _sellFee;
        transferFee = _transferFee;

        emit SetFees(_buyFee, _sellFee, _transferFee);
    }

    function setRewardsExempt(address account, bool isExempt) public onlyOwner {
        require(account != address(0), 'Zero Address');
        permissions[account].rewardsExempt = isExempt;

        if (isExempt) {
            distributor.setShare(account, 0);
        } else {
            distributor.setShare(account, balanceOf(account));
        }
        emit SetRewardsExempt(account, isExempt);
    }

    function DisableIngressTaxation(address account) public onlyOwner {
        require(account != address(0), 'Zero Address');
        require(!permissions[account].isIngressFeeExempt, 'Already Disabled');

        // set tax exemption
        permissions[account].isIngressFeeExempt = true;
        permissions[account].ingressExemptIndex = ingressExemptContracts.length;
        // add to transparency array
        ingressExemptContracts.push(account);
        
        emit SetIngressExemption(account, true);
    }

    function EnableIngressTaxation(address account) external onlyOwner {
        require(account != address(0), 'Zero Address');
        require(permissions[account].isIngressFeeExempt, 'Account Not Disabled');
        require(
            ingressExemptContracts[permissions[account].ingressExemptIndex] == account,
            'Account Does Not Match Index'
        );
        
        // set index of last element to be removal index
        permissions[
            ingressExemptContracts[ingressExemptContracts.length - 1]
        ].ingressExemptIndex = permissions[account].ingressExemptIndex;
        // set position of removal index to be last element of array
        ingressExemptContracts[
            permissions[account].ingressExemptIndex
        ] = ingressExemptContracts[ingressExemptContracts.length - 1];
        // pop duplicate off the end of the array
        ingressExemptContracts.pop();
        // disable tax exemption
        permissions[account].isIngressFeeExempt = false;
        permissions[account].ingressExemptIndex = 0;

        emit SetIngressExemption(account, false);
    }

    function DisableEgressTaxation(address account) public onlyOwner {
        require(account != address(0), 'Zero Address');
        require(!permissions[account].isEgressFeeExempt, 'Already Disabled');

        // set tax exemption
        permissions[account].isEgressFeeExempt = true;
        permissions[account].egressExemptIndex = egressExemptContracts.length;
        // add to transparency array
        egressExemptContracts.push(account);
        
        emit SetEgressExemption(account, true);
    }

    function EnableEgressTaxation(address account) external onlyOwner {
        require(account != address(0), 'Zero Address');
        require(permissions[account].isEgressFeeExempt, 'Account Not Disabled');
        require(
            egressExemptContracts[permissions[account].egressExemptIndex] == account,
            'Account Does Not Match Index'
        );
        
        // set index of last element to be removal index
        permissions[
            egressExemptContracts[egressExemptContracts.length - 1]
        ].egressExemptIndex = permissions[account].egressExemptIndex;
        // set position of removal index to be last element of array
        egressExemptContracts[
            permissions[account].egressExemptIndex
        ] = egressExemptContracts[egressExemptContracts.length - 1];
        // pop duplicate off the end of the array
        egressExemptContracts.pop();
        // disable tax exemption
        permissions[account].isEgressFeeExempt = false;
        permissions[account].egressExemptIndex = 0;

        emit SetEgressExemption(account, false);
    }

    function getTax(address sender, address recipient, uint256 amount) public view returns (uint256, address) {
        if ( permissions[sender].isEgressFeeExempt || permissions[recipient].isIngressFeeExempt ) {
            return (0, address(0));
        }
        return permissions[sender].isLiquidityPool ? 
               (amount.mul(buyFee).div(TAX_DENOM), buyFeeRecipient) : 
               permissions[recipient].isLiquidityPool ? 
               (amount.mul(sellFee).div(TAX_DENOM), sellFeeRecipient) :
               (amount.mul(transferFee).div(TAX_DENOM), transferFeeRecipient);
    }

    receive() external payable {
        (bool s,) = payable(UselessSwapper).call{value: msg.value}("");
        require(s);
    }

    function _burn(address from, uint amount) internal {
        _balances[from] = _balances[from].sub(amount, 'Underflow');
        _totalSupply = _totalSupply.sub(amount, 'Underflow');
    }

}