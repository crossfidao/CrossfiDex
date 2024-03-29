// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IERC20 {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address to, uint256 amount) external returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

interface ISwapFactory {
    function getPair(address tokenA, address tokenB)
        external
        view
        returns (address pair);

    function allPairs(uint256) external view returns (address pair);

    function allPairsLength() external view returns (uint256);

    function createPair(address tokenA, address tokenB)
        external
        returns (address pair);
}

interface ISwapRouter {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
        external
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        );

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (
            uint256 amountToken,
            uint256 amountETH,
            uint256 liquidity
        );

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETH(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountToken, uint256 amountETH);

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapTokensForExactETH(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactTokensForETH(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapETHForExactTokens(
        uint256 amountOut,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function quote(
        uint256 amountA,
        uint256 reserveA,
        uint256 reserveB
    ) external pure returns (uint256 amountB);

    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountOut);

    function getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountIn);

    function getAmountsOut(uint256 amountIn, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);

    function getAmountsIn(uint256 amountOut, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
}

library Address {
    function isContract(address account) internal view returns (bool) {
        return account.code.length > 0;
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(
            address(this).balance >= amount,
            "Address: insufficient balance"
        );
        (bool success, ) = recipient.call{value: amount}("");
        require(
            success,
            "Address: unable to send value, recipient may have reverted"
        );
    }

    function functionCall(address target, bytes memory data)
        internal
        returns (bytes memory)
    {
        return functionCall(target, data, "Address: low-level call failed");
    }

    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return
            functionCallWithValue(
                target,
                data,
                value,
                "Address: low-level call with value failed"
            );
    }

    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(
            address(this).balance >= value,
            "Address: insufficient balance for call"
        );
        require(isContract(target), "Address: call to non-contract");
        (bool success, bytes memory returndata) = target.call{value: value}(
            data
        );
        return verifyCallResult(success, returndata, errorMessage);
    }

    function functionStaticCall(address target, bytes memory data)
        internal
        view
        returns (bytes memory)
    {
        return
            functionStaticCall(
                target,
                data,
                "Address: low-level static call failed"
            );
    }

    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");
        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    function functionDelegateCall(address target, bytes memory data)
        internal
        returns (bytes memory)
    {
        return
            functionDelegateCall(
                target,
                data,
                "Address: low-level delegate call failed"
            );
    }

    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            if (returndata.length > 0) {
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

library SafeMath {
    function tryAdd(uint256 a, uint256 b)
        internal
        pure
        returns (bool, uint256)
    {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    function trySub(uint256 a, uint256 b)
        internal
        pure
        returns (bool, uint256)
    {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    function tryMul(uint256 a, uint256 b)
        internal
        pure
        returns (bool, uint256)
    {
        unchecked {
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

    function tryDiv(uint256 a, uint256 b)
        internal
        pure
        returns (bool, uint256)
    {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    function tryMod(uint256 a, uint256 b)
        internal
        pure
        returns (bool, uint256)
    {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }

    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }

    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }

    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}

contract Ownable {
    address private _owner;
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() {
        _transferOwnership(_msgSender());
    }

    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

contract Manager is Ownable {
    address public manager;
    modifier onlyManager() {
        require(
            owner() == _msgSender() || manager == _msgSender(),
            "Ownable: Not Manager"
        );
        _;
    }

    function setManager(address account) public virtual onlyManager {
        manager = account;
    }
}

contract FilswapIDO is Manager {
    using SafeMath for uint256;
    using Address for address;
    struct PoolInfo {
        bool isExist;
        bool isUSDT;
        bool isWhite;
        uint256 startTime;
        uint256 endTime;
        uint256 totalMax;
        uint256 totalHas;
        uint256 price;
        uint256 userMin;
        uint256 userMax;
        uint256 amount;
    }
    struct PoolInfoLock {
        bool isAddLP;
        uint256 lpAmount;
        uint256 lockType;
        uint256 lockTimes;
        address adminAdd;
    }
    struct UserInfo {
        bool isExist;
        bool isUSDT;
        uint256 amount;
        uint256 balance;
        uint256 withdraw;
    }
    mapping(address => mapping(address => UserInfo)) public users;
    mapping(address => mapping(uint256 => address)) public userAdds;
    mapping(address => uint256) public userTotals;
    mapping(address => PoolInfo) public pools;
    mapping(address => PoolInfoLock) public poolLocks;
    mapping(uint256 => address) public poolAdds;
    mapping(address => address[]) public poolWhites;
    uint256 public poolTotal;
    ISwapRouter private _swapRouter;
    ISwapFactory private _swapFactory;
    IERC20 private _USDT;
    event Deposit(address lp, address user, uint256 amount);
    event Relieve(address lp, address user, uint256 amount);
    event Withdraw(
        address lp,
        address user,
        uint256 amountToken,
        uint256 amountCRFI
    );
    event AddPool(address token, uint256 amount);
    event SetPool(address token, uint256 amount);

    constructor() {
        manager = msg.sender;
        _USDT = IERC20(0x37B2a17445eA8e388099195E0338aFbFbf1D0696);
        address routerAddress = 0xE72C143264B1b89080f352dE492a9463D435e2E1;
        _swapRouter = ISwapRouter(routerAddress);
        _swapFactory = ISwapFactory(_swapRouter.factory());
    }

    receive() external payable {}

    function withdrawETH() public onlyManager {
        payable(msg.sender).transfer(address(this).balance);
    }

    function withdrawToken(IERC20 token) public onlyManager {
        token.transfer(msg.sender, token.balanceOf(address(this)));
    }

    function getPools()
        public
        view
        returns (
            address[] memory lps,
            PoolInfo[] memory pls,
            PoolInfoLock[] memory plks,
            uint256[] memory uts
        )
    {
        lps = new address[](poolTotal);
        pls = new PoolInfo[](poolTotal);
        plks = new PoolInfoLock[](poolTotal);
        uts = new uint256[](poolTotal);
        for (uint256 i = 0; i < poolTotal; i++) {
            lps[i] = poolAdds[i + 1];
            pls[i] = pools[lps[i]];
            plks[i] = poolLocks[lps[i]];
            uts[i] = userTotals[lps[i]];
        }
    }

    function getPoolWithUsers(address account)
        public
        view
        returns (
            address[] memory lps,
            PoolInfo[] memory pls,
            uint256[] memory uts,
            UserInfo[] memory urs,
            uint256[] memory crfis,
            uint256[] memory tokens
        )
    {
        lps = new address[](poolTotal);
        pls = new PoolInfo[](poolTotal);
        uts = new uint256[](poolTotal);
        urs = new UserInfo[](poolTotal);
        crfis = new uint256[](poolTotal);
        tokens = new uint256[](poolTotal);
        for (uint256 i = 0; i < poolTotal; i++) {
            lps[i] = poolAdds[i + 1];
            pls[i] = pools[lps[i]];
            uts[i] = userTotals[lps[i]];
            urs[i] = users[lps[i]][account];
            if (urs[i].isExist) {}
        }
    }

    function addPool(
        IERC20 token,
        address adminAdd,
        bool isUSDT,
        bool isWhite,
        uint256 total,
        uint256[] memory args,
        address[] memory whiteList
    ) public onlyManager {
        require(!pools[address(token)].isExist, "Pool is Exist");
        require(token.balanceOf(msg.sender) >= total, "Insufficient Token");
        token.transferFrom(msg.sender, address(this), total);
        uint256 totalToken = token.balanceOf(address(this));
        require(args.length == 7, "");
        {
            pools[address(token)] = PoolInfo({
                isExist: true,
                isUSDT: isUSDT,
                isWhite: isWhite,
                totalMax: totalToken / 2,
                totalHas: 0,
                startTime: args[0],
                endTime: args[1],
                price: args[2],
                userMin: args[3],
                userMax: args[4],
                amount: 0
            });
        }
        {
            poolLocks[address(token)] = PoolInfoLock({
                isAddLP: false,
                lpAmount: 0,
                lockType: args[5],
                lockTimes: args[6],
                adminAdd: adminAdd
            });
        }
        {
            poolWhites[address(token)] = whiteList;
            poolTotal = poolTotal.add(1);
            poolAdds[poolTotal] = address(token);
        }
        emit AddPool(address(token), total);
    }

    function removePool(IERC20 token) public onlyManager {
        require(pools[address(token)].isExist, "Pool is Exist");
        require(
            pools[address(token)].startTime > block.timestamp,
            "Pool has Start"
        );
        token.transfer(msg.sender, token.balanceOf(address(this)));
        delete pools[address(token)];
        delete poolLocks[address(token)];
        delete poolWhites[address(token)];
        for (uint256 index = 0; index < poolTotal; index++) {
            if (
                poolAdds[index + 1] == address(token) && index + 1 != poolTotal
            ) {
                poolAdds[index + 1] = poolAdds[poolTotal];
                delete poolAdds[poolTotal];
                break;
            }
        }
    }

    function addLP(address token) public {
        PoolInfo storage pool = pools[token];
        PoolInfoLock storage poolLock = poolLocks[token];
        require(pool.isExist, "Pool Not Exist");
        require(!poolLock.isAddLP, "Swap Has Create");
        require(poolLock.adminAdd == msg.sender, "Not Admin");
        if (pool.isUSDT) {
            _addLiquidityUSDT(IERC20(token), pool.totalHas, pool.amount);
        } else {
            _addLiquidityETH(IERC20(token), pool.totalHas, pool.amount);
        }
        poolLock.isAddLP = true;
    }

    function withdrawLP(address token) public {
        PoolInfo storage pool = pools[token];
        PoolInfoLock storage poolLock = poolLocks[token];
        require(pool.isExist, "Pool Not Exist");
        require(block.timestamp >= pool.endTime, "Fail: Not End");
        require(poolLock.isAddLP, "Swap Not Create");
        require(poolLock.adminAdd == msg.sender, "Not Admin");
        require(
            block.timestamp >= pool.endTime + 90 * 86400,
            "Fail: Not Release"
        );
        if (pool.isUSDT) {
            address pair = _swapFactory.getPair(token, address(_USDT));
            require(pair != address(0), "Fail: Pair is zero");
            uint256 balance = IERC20(pair).balanceOf(address(this));
            IERC20(pair).transfer(poolLock.adminAdd, balance);
        } else {
            address pair = _swapFactory.getPair(token, _swapRouter.WETH());
            require(pair != address(0), "Fail: Pair is zero");
            uint256 balance = IERC20(pair).balanceOf(address(this));
            IERC20(pair).transfer(poolLock.adminAdd, balance);
        }
    }

    function ido(address token, uint256 amount) public payable {
        PoolInfo storage pool = pools[token];
        require(pool.isExist, "Pool Not Exist");
        require(block.timestamp > pool.startTime, "Fail: not start");
        require(block.timestamp <= pool.endTime, "Fail: has end");
        require(amount >= pool.userMin, "Fail: Too lower");
        if (pool.isWhite) {
            bool isExist;
            for (uint256 i = 0; i < poolWhites[token].length; i++) {
                if (poolWhites[token][i] == msg.sender) {
                    isExist = true;
                    break;
                }
            }
            require(isExist, "Fail: Not White");
        }
        uint256 balance = amount.mul(10**18).div(pool.price);
        require(pool.totalHas.add(balance) <= pool.totalMax, "Fail: Total Max");
        if (pool.isUSDT) {
            _USDT.transferFrom(msg.sender, address(this), amount);
        } else {
            require(msg.value == amount, "Fail: amount not math");
        }
        pool.totalHas += balance;
        pool.amount += amount;
        UserInfo storage user = users[token][msg.sender];
        require(user.amount.add(amount) <= pool.userMax, "Fail: Too max");
        if (!user.isExist) {
            user.isExist = true;
            user.isUSDT = pool.isUSDT;
            userTotals[token] = userTotals[token].add(1);
            userAdds[token][userTotals[token]] = msg.sender;
        }
        user.amount = user.amount.add(amount);
        user.balance = user.balance.add(balance);
    }

    function withdrawIDO(address token) public {
        PoolInfo storage pool = pools[token];
        PoolInfoLock storage poolLock = poolLocks[token];
        require(pool.isExist, "Pool Not Exist");
        require(block.timestamp >= pool.endTime, "Fail: Not End");
        require(poolLock.isAddLP, "Swap Not Create");
        UserInfo storage user = users[token][msg.sender];
        if (poolLock.lockType == 0) {
            require(user.balance > 0, "Fail: no balance");
            IERC20(token).transfer(msg.sender, user.balance);
            user.withdraw = user.balance;
        } else {
            uint256 every = user.balance / poolLock.lockTimes;
            uint256 timeStep = poolLock.lockType == 1
                ? 30 * 86400
                : (poolLock.lockType == 2 ? 120 * 86400 : 365 * 86400);
            uint256 times = (block.timestamp - pool.endTime) / timeStep;
            uint256 pending = (times * every) - user.withdraw;
            require(pending > 0, "Fail: No Pending");
            IERC20(token).transfer(msg.sender, pending);
            user.withdraw += pending;
        }
    }

    function getUserPending(address token, address account)
        external
        view
        returns (uint256 pending)
    {
        PoolInfo memory pool = pools[token];
        PoolInfoLock memory poolLock = poolLocks[token];
        if (
            !pool.isExist || !poolLock.isAddLP || block.timestamp < pool.endTime
        ) return 0;
        UserInfo memory user = users[token][account];
        if (poolLock.lockType == 0) {
            return user.balance;
        } else {
            uint256 every = user.balance / poolLock.lockTimes;
            uint256 timeStep = poolLock.lockType == 1
                ? 30 * 86400
                : (poolLock.lockType == 2 ? 120 * 86400 : 365 * 86400);
            uint256 times = (block.timestamp - pool.endTime) / timeStep;
            pending = (times * every) - user.withdraw;
            return pending;
        }
    }

    function _addLiquidityUSDT(
        IERC20 token,
        uint256 tokenAmount,
        uint256 usdtAmount
    ) internal {
        token.approve(address(_swapRouter), tokenAmount);
        _USDT.approve(address(_swapRouter), usdtAmount);
        _swapRouter.addLiquidity(
            address(token),
            address(_USDT),
            tokenAmount,
            usdtAmount,
            0,
            0,
            address(this),
            block.timestamp
        );
        emit AddLiquidity(address(token), tokenAmount, usdtAmount);
    }

    function _addLiquidityETH(
        IERC20 token,
        uint256 tokenAmount,
        uint256 ethAmount
    ) internal {
        token.approve(address(_swapRouter), tokenAmount);
        _swapRouter.addLiquidityETH{value: ethAmount}(
            address(token),
            tokenAmount,
            0,
            0,
            address(this),
            block.timestamp
        );
        emit AddLiquidity(address(token), tokenAmount, ethAmount);
    }

    event AddLiquidity(address token, uint256 tokenAmount, uint256 usdtAmount);
}
