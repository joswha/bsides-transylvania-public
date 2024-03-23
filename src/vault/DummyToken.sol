pragma solidity 0.8.23;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount)
        external;
    function allowance(address owner, address spender)
        external
        view
        returns (uint256);
    function approve(address spender, uint256 amount) external;
    function transferFrom(address sender, address recipient, uint256 amount)
        external;
}

contract DummyToken is IERC20 {
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    uint8 public decimals = 18;

    function transfer(address recipient, uint256 amount)
        external
    {
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
    }

    function approve(address spender, uint256 amount) external {
        allowance[msg.sender][spender] = amount;
    }

    function transferFrom(address sender, address recipient, uint256 amount)
        external
    {
        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
    }

    // NOTE anyone can call on purpose; it's not a bug
    function mint(address dst, uint256 amount) external {
        balanceOf[dst] += amount;
        totalSupply += amount;
    }

    // NOTE anyone can call on purpose; it's not a bug
    function burn(uint256 amount) external {
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
    }
}