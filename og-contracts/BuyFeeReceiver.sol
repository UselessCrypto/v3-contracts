//SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "./Ownable.sol";
import "./IERC20.sol";

interface Depositor {
    function deposit(uint256 amount) external;
}

contract BuyFeeReceiver is Ownable {

    // USELESS token
    address public constant token = 0x3485D4C9E7a7717466b3276Fbf3311aD3C1bE7Af;

    // Sources To Receive Tokens
    address public furnace;
    address public multisig;
    address public stakingContract;

    // events
    event SetFurnace(address newFurnace);
    event SetMultisig(address newMultisig);
    event SetStakingContract(address newStakingContract);

    function trigger() external {
        uint balance = IERC20(token).balanceOf(address(this));
        IERC20(token).transfer(furnace, balance / 3);        
        IERC20(token).transfer(multisig, balance / 3);
        IERC20(token).approve(stakingContract, IERC20(token).balanceOf(address(this)));
        Depositor(stakingContract).deposit(IERC20(token).balanceOf(address(this)));
    }

    function setFurnace(address furnace_) external onlyOwner {
        require(furnace_ != address(0), 'Zero Address');
        furnace = furnace_;
        emit SetFurnace(furnace_);
    }
    function setMultisig(address multisig_) external onlyOwner {
        require(multisig_ != address(0), 'Zero Address');
        multisig = multisig_;
        emit SetMultisig(multisig_);
    }
    function setStakingContract(address stakingContract_) external onlyOwner {
        require(stakingContract_ != address(0), 'Zero Address');
        stakingContract = stakingContract_;
        emit SetStakingContract(stakingContract_);
    }
    function withdraw() external onlyOwner {
        (bool s,) = payable(msg.sender).call{value: address(this).balance}("");
        require(s);
    }
    function withdraw(address token_) external onlyOwner {
        IERC20(token_).transfer(msg.sender, IERC20(token_).balanceOf(address(this)));
    }
    receive() external payable {}
}