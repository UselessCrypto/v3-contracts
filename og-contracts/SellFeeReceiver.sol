//SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "./Ownable.sol";
import "./IERC20.sol";
import "./IUniswapV2Router02.sol";

contract SellFeeReceiver is Ownable {

    // USELESS token
    address public constant token = 0xC079d0385492Ac2D0e89ca079c186Dd71ef49B1e;

    // router
    IUniswapV2Router02 router = IUniswapV2Router02(0x32253394e1C9E33C0dA3ddD54cDEff07E457A687);

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
        path = new address[](2);
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
        (bool s,) = payable(msg.sender).call{value: address(this).balance}("");
        require(s);
    }
    function withdraw(address token_) external onlyOwner {
        IERC20(token_).transfer(msg.sender, IERC20(token_).balanceOf(address(this)));
    }
    receive() external payable {}
    function _send(address recipient, uint amount) internal {
        (bool s,) = payable(recipient).call{value: amount}("");
        require(s);
    }
}