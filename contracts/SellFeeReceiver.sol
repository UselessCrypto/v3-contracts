//SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "./Ownable.sol";
import "./IERC20.sol";
import "./IUniswapV2Router02.sol";

contract SellFeeReceiver is Ownable {

    // USELESS token
    address public constant token = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    // router
    IUniswapV2Router02 router = IUniswapV2Router02(0x10ED43C718714eb63d5aA57B78B54704E256024E);

    // recipients
    address public furnace;
    address public multisig;
    address public distributor;

    // Token -> ONE
    address[] path;

    // events
    event SetFurnace(address newFurnace);
    event SetMultisig(address newMultisig);
    event SetDistributor(address newDistributor);

    constructor() {
        path = address[](2);
        path[0] = token;
        path[1] = router.WETH();
    }

    function trigger() external {

        // give portion of tokens to furnace
        IERC20(token).transfer(furnace, IERC20(token).balanceOf(address(this)) / 3);

        // sell useless in contract for ONE
        uint balance = IERC20(token).balanceOf(address(this));
        IERC20(token).approve(address(router), balance);
        router.swapExactTokensForETHSupportingFeeOnTransferTokens(balance, 0, path, address(this), block.timestamp + 300);

        // send to destinations
        _send(multisig, address(this).balance / 2);
        _send(distributor, address(this).balance);
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
    function setDistributor(address distributor_) external onlyOwner {
        require(distributor_ != address(0), 'Zero Address');
        distributor = distributor_;
        emit SetDistributor(distributor_);
    }
    function withdraw() external onlyOwner {
        (bool s,) = payable(owner).call{vaule: address(this).balance}("");
        require(s);
    }
    function withdraw(address token) external onlyOwner {
        IERC20(token).transfer(owner, IERC20(token).balanceOf(address(this)));
    }
    receive() external payable {}
    function _send(address recipient, uint amount) internal {
        (bool s,) = payable(recipient).call{vaule: amount}("");
        require(s);
    }
}