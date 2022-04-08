import "./IUniswapV2Router02.sol";
import "./ReentrantGuard.sol";
import "./SafeMath.sol";

contract EclipseSwapper is ReentrancyGuard {

    using SafeMath for uint256;
    
    address constant _v2router = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    address _master;
        
    constructor() {
        _master = msg.sender;
    }

    function buyToken(address token, address receiver) external payable nonReentrant{
        _buyToken(token, receiver, _v2router);
    }
    
    function buyTokenCustomRouter(address token, address receiver, address router) external payable nonReentrant {
        _buyToken(token, receiver, router);
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }
    
    function _buyToken(address token, address receiver, address router) private {
        require(msg.value >= 10**9, 'Purchase Too Small');    
        
        IUniswapV2Router02 customRouter = IUniswapV2Router02(router);
        address[] memory path = new address[](2);
        path[0] = customRouter.WETH();
        path[1] = token;
                
        uint256 swapAmount = msg.value;
        
        customRouter.swapExactETHForTokens{value:swapAmount}(
            0,
            path,
            receiver,
            block.timestamp.add(30)
        );       
    }
}
