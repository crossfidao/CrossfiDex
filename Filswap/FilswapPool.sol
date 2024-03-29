// SPDX-License-Identifier: MIT
//质押token 挖矿
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

contract FilswapPool is Manager {
    using SafeMath for uint256;
    using Address for address;
    struct PoolInfo {
        bool isExist;
        bool isValid;
        uint256 minTimes;
        uint256 startBlock;
        uint256 totalBlock;
        uint256 endBlock;
        uint256 lastBlock;
        uint256 tokenTotal;
        uint256 tokenPerBlock;
        uint256 tokenPerLP;
        uint256 crfiTotal;
        uint256 crfiPerBlock;
        uint256 crfiPerLP;
        uint256 totalStake;
    }
    struct UserInfo {
        bool isExist;
        uint256 lastTime;
        uint256 amount;
        uint256 tokenDebt;
        uint256 crfiDebt;
        uint256 tokenBalance;
        uint256 crfiBalance;
        uint256 tokenTotal;
        uint256 crfiTotal;
    }
    mapping(address => mapping(address => UserInfo)) public users;
    mapping(address => mapping(uint256 => address)) public userAdds;
    mapping(address => uint256) userTotals;
    mapping(address => PoolInfo) public pools;
    mapping(uint256 => address) public poolAdds;
    mapping(address => uint256) upIndex;
    uint256 public poolTotal;
    uint256 public feeTax;
    address public feeTo;
    IERC20 private _CRFI;
    event Deposit(address token, address user, uint256 amount);
    event Relieve(
        address token,
        address user,
        uint256 amount,
        uint256 amountFee
    );
    event Withdraw(
        address token,
        address user,
        uint256 amountToken,
        uint256 amountCRFI
    );
    event AddPool(
        address token,
        uint256 amountToken,
        uint256 amountCRFI,
        uint256 totalBlock
    );
    event SetPool(
        address token,
        uint256 amountToken,
        uint256 amountCRFI,
        uint256 totalBlock
    );

    constructor() {
        feeTax = 10;
        feeTo = msg.sender;
        manager = msg.sender;
        _CRFI = IERC20(0xC2eE95E0220A9f19a7457376d2DAe455EF4a8394);
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
            uint256[] memory uts
        )
    {
        pls = new PoolInfo[](poolTotal);
        lps = new address[](poolTotal);
        uts = new uint256[](poolTotal);
        for (uint256 i = 0; i < poolTotal; i++) {
            lps[i] = poolAdds[i + 1];
            pls[i] = pools[lps[i]];
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
        pls = new PoolInfo[](poolTotal);
        lps = new address[](poolTotal);
        uts = new uint256[](poolTotal);
        urs = new UserInfo[](poolTotal);
        crfis = new uint256[](poolTotal);
        tokens = new uint256[](poolTotal);
        for (uint256 i = 0; i < poolTotal; i++) {
            lps[i] = poolAdds[i + 1];
            pls[i] = pools[lps[i]];
            uts[i] = userTotals[lps[i]];
            urs[i] = users[lps[i]][account];
            if (urs[i].isExist) {
                uint256 crfiPerLp = pls[i].crfiPerLP;
                uint256 tokenPerLp = pls[i].tokenPerLP;
                if (
                    pls[i].totalStake != 0 && pls[i].endBlock > pls[i].lastBlock
                ) {
                    uint256 multiplier = _getMultiplier(
                        pls[i].endBlock,
                        pls[i].lastBlock
                    );
                    uint256 rewardToken = multiplier.mul(pls[i].tokenPerBlock);
                    uint256 rewardCRFI = multiplier.mul(pls[i].crfiPerBlock);
                    tokenPerLp = tokenPerLp.add(
                        rewardToken.mul(1e12).div(pls[i].totalStake)
                    );
                    crfiPerLp = crfiPerLp.add(
                        rewardCRFI.mul(1e12).div(pls[i].totalStake)
                    );
                }
                crfis[i] = urs[i]
                    .amount
                    .mul(crfiPerLp)
                    .div(1e12)
                    .sub(urs[i].crfiDebt)
                    .add(urs[i].crfiBalance);
                tokens[i] = urs[i]
                    .amount
                    .mul(tokenPerLp)
                    .div(1e12)
                    .sub(urs[i].tokenDebt)
                    .add(urs[i].tokenBalance);
            } else {
                crfis[i] = 0;
                tokens[i] = 0;
            }
        }
    }

    function addPool(
        IERC20 token,
        uint256 amountToken,
        uint256 amountCRFI,
        uint256 startBlock,
        uint256 totalBlock,
        uint256 minTimes
    ) public onlyManager {
        require(!pools[address(token)].isExist, "Pool is Exist");
        require(_CRFI.balanceOf(msg.sender) >= amountCRFI, "Insufficient CRFI");
        require(
            token.balanceOf(msg.sender) >= amountToken,
            "Insufficient Token"
        );
        uint256 tokenBefore = token.balanceOf(address(this));
        if (amountToken > 0)
            token.transferFrom(msg.sender, address(this), amountToken);
        if (amountCRFI > 0)
            _CRFI.transferFrom(msg.sender, address(this), amountCRFI);
        uint256 amountTokenActual = token.balanceOf(address(this)).sub(
            tokenBefore
        );
        pools[address(token)] = PoolInfo({
            isExist: true,
            isValid: true,
            minTimes: minTimes,
            startBlock: startBlock,
            totalBlock: totalBlock,
            endBlock: 0,
            lastBlock: block.number,
            tokenTotal: amountTokenActual,
            tokenPerBlock: amountTokenActual.div(totalBlock),
            tokenPerLP: 0,
            crfiTotal: amountCRFI,
            crfiPerBlock: amountCRFI.div(totalBlock),
            crfiPerLP: 0,
            totalStake: 0
        });
        poolTotal = poolTotal.add(1);
        poolAdds[poolTotal] = address(token);
        emit AddPool(address(token), amountToken, amountCRFI, totalBlock);
    }

    function setPool(
        address token,
        uint256 amountToken,
        uint256 amountCRFI,
        uint256 startBlock,
        uint256 totalBlock,
        uint256 minTimes
    ) public onlyManager {
        require(pools[token].isExist, "Pool Not Exist");
        require(amountToken > 0, "Token Amount Not Zero");
        require(_CRFI.balanceOf(msg.sender) >= amountCRFI, "Insufficient CRFI");
        IERC20 tokenERC = IERC20(token);
        require(
            tokenERC.balanceOf(msg.sender) >= amountToken,
            "Insufficient Token"
        );
        uint256 tokenBefore = tokenERC.balanceOf(address(this));
        tokenERC.transferFrom(msg.sender, address(this), amountToken);
        uint256 amountTokenActual = tokenERC.balanceOf(address(this)).sub(
            tokenBefore
        );
        if (amountCRFI > 0) {
            _CRFI.transferFrom(msg.sender, address(this), amountCRFI);
        }
        updatePool(token);
        PoolInfo storage pool = pools[token];
        if (pool.endBlock > pool.lastBlock) {
            uint256 blocks = pool.endBlock.sub(pool.lastBlock);
            pool.tokenTotal = pool.tokenPerBlock.mul(blocks).add(
                amountTokenActual
            );
            pool.tokenPerBlock = pool.tokenTotal.div(totalBlock);
            pool.crfiTotal = pool.crfiPerBlock.mul(blocks).add(amountCRFI);
            pool.crfiPerBlock = pool.crfiTotal.div(totalBlock);
            pool.endBlock = pool.lastBlock.add(totalBlock);
            pool.startBlock = startBlock;
            pool.totalBlock = totalBlock;
            pool.minTimes = minTimes;
            if (!pool.isValid) pool.isValid = true;
        } else {
            uint256 total = userTotals[token];
            for (uint256 i = 0; i < total; i++) {
                address account = userAdds[token][i + 1];
                if (users[token][account].amount > 0) {
                    UserInfo storage user = users[token][account];
                    uint256 pendingCRFI = user
                        .amount
                        .mul(pool.crfiPerLP)
                        .div(1e12)
                        .sub(user.crfiDebt);
                    if (pendingCRFI > 0) {
                        user.crfiBalance = user.crfiBalance.add(pendingCRFI);
                        user.crfiTotal = user.crfiTotal.add(pendingCRFI);
                    }
                    uint256 pendingToken = user
                        .amount
                        .mul(pool.tokenPerLP)
                        .div(1e12)
                        .sub(user.tokenDebt);
                    if (pendingToken > 0) {
                        user.tokenBalance = user.tokenBalance.add(pendingToken);
                        user.tokenTotal = user.tokenTotal.add(pendingToken);
                    }
                    user.tokenDebt = user.amount.mul(pool.tokenPerLP).div(1e12);
                    user.crfiDebt = user.amount.mul(pool.crfiPerLP).div(1e12);
                }
            }
            pool.tokenTotal = amountTokenActual;
            pool.tokenPerBlock = pool.tokenTotal.div(totalBlock);
            pool.crfiTotal = amountCRFI;
            pool.crfiPerBlock = pool.crfiTotal.div(totalBlock);
            pool.lastBlock = block.number;
            pool.tokenPerLP = 0;
            pool.startBlock = startBlock;
            pool.totalBlock = totalBlock;
            if (pool.totalStake == 0) {
                pool.endBlock = 0;
            } else {
                pool.endBlock = pool.lastBlock.add(totalBlock);
            }
            pool.minTimes = minTimes;
            if (!pool.isValid) pool.isValid = true;
        }
        emit SetPool(token, amountToken, amountCRFI, totalBlock);
    }

    function updateUser(address token, uint256 times) public {
        PoolInfo storage pool = pools[token];
        uint256 total = userTotals[token];
        uint256 index;
        uint256 step;
        for (uint256 i = upIndex[token]; i < total; i++) {
            if (users[token][userAdds[token][i + 1]].amount > 0) {
                UserInfo storage user = users[token][userAdds[token][i + 1]];
                uint256 pendingCRFI = user
                    .amount
                    .mul(pool.crfiPerLP)
                    .div(1e12)
                    .sub(user.crfiDebt);
                if (pendingCRFI > 0) {
                    user.crfiBalance = user.crfiBalance.add(pendingCRFI);
                    user.crfiTotal = user.crfiTotal.add(pendingCRFI);
                }
                uint256 pendingToken = user
                    .amount
                    .mul(pool.tokenPerLP)
                    .div(1e12)
                    .sub(user.tokenDebt);
                if (pendingToken > 0) {
                    user.tokenBalance = user.tokenBalance.add(pendingToken);
                    user.tokenTotal = user.tokenTotal.add(pendingToken);
                }
                user.tokenDebt = user.amount.mul(pool.tokenPerLP).div(1e12);
                user.crfiDebt = user.amount.mul(pool.crfiPerLP).div(1e12);
                index++;
            }
            step++;
            if (index++ > times || (upIndex[token] + step) >= total) {
                break;
            }
        }
        if ((upIndex[token] + step) >= total) upIndex[token] = 0;
        else upIndex[token] += step;
    }

    function deposit(address token, uint256 amount) public {
        require(amount > 0, "Amount Not Zero");
        require(block.number > pools[token].startBlock, "Not Start");
        require(_CRFI.balanceOf(msg.sender) >= amount, "Insufficient CRFI");
        require(pools[token].isExist, "Pool Not Exist");
        require(pools[token].isValid, "Pool Not Valid");
        updatePool(token);
        PoolInfo storage pool = pools[token];
        require(pool.isValid, "Pool Not Valid");
        UserInfo storage user = users[token][msg.sender];
        if (user.amount > 0) {
            uint256 pendingCRFI = user.amount.mul(pool.crfiPerLP).div(1e12).sub(
                user.crfiDebt
            );
            if (pendingCRFI > 0) {
                user.crfiBalance = user.crfiBalance.add(pendingCRFI);
                user.crfiTotal = user.crfiTotal.add(pendingCRFI);
            }
            uint256 pendingToken = user
                .amount
                .mul(pool.tokenPerLP)
                .div(1e12)
                .sub(user.tokenDebt);
            if (pendingToken > 0) {
                user.tokenBalance = user.tokenBalance.add(pendingToken);
                user.tokenTotal = user.tokenTotal.add(pendingToken);
            }
        }
        _CRFI.transferFrom(address(msg.sender), address(this), amount);
        pool.totalStake = pool.totalStake.add(amount);
        user.lastTime = block.timestamp;
        user.amount = user.amount.add(amount);
        user.tokenDebt = user.amount.mul(pool.tokenPerLP).div(1e12);
        user.crfiDebt = user.amount.mul(pool.crfiPerLP).div(1e12);
        if (!user.isExist) {
            user.isExist = true;
            userTotals[token] = userTotals[token].add(1);
            userAdds[token][userTotals[token]] = msg.sender;
        }
        emit Deposit(token, msg.sender, amount);
    }

    function relieve(address token, uint256 amount) public {
        require(amount > 0, "Amount Not Zero");
        require(pools[token].isExist, "Pool Not Exist");
        UserInfo storage user = users[token][msg.sender];
        require(user.amount >= amount, "withdraw: not good");
        updatePool(token);
        PoolInfo storage pool = pools[token];
        uint256 pendingCRFI = user.amount.mul(pool.crfiPerLP).div(1e12).sub(
            user.crfiDebt
        );
        if (pendingCRFI > 0) {
            user.crfiBalance = user.crfiBalance.add(pendingCRFI);
            user.crfiTotal = user.crfiTotal.add(pendingCRFI);
        }
        uint256 pendingToken = user.amount.mul(pool.tokenPerLP).div(1e12).sub(
            user.tokenDebt
        );
        if (pendingToken > 0) {
            user.tokenBalance = user.tokenBalance.add(pendingToken);
            user.tokenTotal = user.tokenTotal.add(pendingToken);
        }
        user.amount = user.amount.sub(amount);
        uint256 amountFee;
        if (
            feeTax > 0 &&
            feeTo != address(0) &&
            block.timestamp < user.lastTime.add(pool.minTimes)
        ) {
            amountFee = amount.mul(feeTax).div(10000);
            _CRFI.transfer(feeTo, amountFee);
        }
        _CRFI.transfer(msg.sender, amount.sub(amountFee));
        pool.totalStake = pool.totalStake.sub(amount);
        user.tokenDebt = user.amount.mul(pool.tokenPerLP).div(1e12);
        user.crfiDebt = user.amount.mul(pool.crfiPerLP).div(1e12);
        emit Relieve(token, msg.sender, amount, amountFee);
    }

    function withdraw(address token) public {
        require(pools[token].isExist, "Pool Not Exist");
        UserInfo storage user = users[token][msg.sender];
        updatePool(token);
        PoolInfo memory pool = pools[token];
        uint256 pendingCRFI = user.amount.mul(pool.crfiPerLP).div(1e12).sub(
            user.crfiDebt
        );
        if (pendingCRFI > 0) {
            user.crfiBalance = user.crfiBalance.add(pendingCRFI);
            user.crfiTotal = user.crfiTotal.add(pendingCRFI);
        }
        uint256 pendingToken = user.amount.mul(pool.tokenPerLP).div(1e12).sub(
            user.tokenDebt
        );
        if (pendingToken > 0) {
            user.tokenBalance = user.tokenBalance.add(pendingToken);
            user.tokenTotal = user.tokenTotal.add(pendingToken);
        }
        user.tokenDebt = user.amount.mul(pool.tokenPerLP).div(1e12);
        user.crfiDebt = user.amount.mul(pool.crfiPerLP).div(1e12);
        if (user.tokenBalance > 0)
            IERC20(token).transfer(msg.sender, user.tokenBalance);
        if (user.crfiBalance > 0) _CRFI.transfer(msg.sender, user.crfiBalance);
        emit Withdraw(token, msg.sender, user.tokenBalance, user.crfiBalance);
        user.tokenBalance = 0;
        user.crfiBalance = 0;
    }

    function getUserPending(address token, address account)
        external
        view
        returns (uint256 crfi, uint256 reward)
    {
        UserInfo memory user = users[token][account];
        PoolInfo memory pool = pools[token];
        uint256 crfiPerLp = pool.crfiPerLP;
        uint256 tokenPerLp = pool.tokenPerLP;
        if (pool.totalStake != 0) {
            uint256 multiplier = _getMultiplier(pool.endBlock, pool.lastBlock);
            uint256 rewardToken = multiplier.mul(pool.tokenPerBlock);
            uint256 rewardCRFI = multiplier.mul(pool.crfiPerBlock);
            tokenPerLp = tokenPerLp.add(
                rewardToken.mul(1e12).div(pool.totalStake)
            );
            crfiPerLp = crfiPerLp.add(
                rewardCRFI.mul(1e12).div(pool.totalStake)
            );
        }
        crfi = user.amount.mul(crfiPerLp).div(1e12).sub(user.crfiDebt).add(
            user.crfiBalance
        );
        reward = user.amount.mul(tokenPerLp).div(1e12).sub(user.tokenDebt).add(
            user.tokenBalance
        );
    }

    function getUserReward(address token, address account)
        external
        view
        returns (uint256 crfi, uint256 reward)
    {
        UserInfo memory user = users[token][account];
        PoolInfo memory pool = pools[token];
        uint256 crfiPerLp = pool.crfiPerLP;
        uint256 tokenPerLp = pool.tokenPerLP;
        if (pool.totalStake != 0) {
            uint256 multiplier = _getMultiplier(pool.endBlock, pool.lastBlock);
            uint256 rewardToken = multiplier.mul(pool.tokenPerBlock);
            uint256 rewardCRFI = multiplier.mul(pool.crfiPerBlock);
            tokenPerLp = tokenPerLp.add(
                rewardToken.mul(1e12).div(pool.totalStake)
            );
            crfiPerLp = crfiPerLp.add(
                rewardCRFI.mul(1e12).div(pool.totalStake)
            );
        }
        crfi = user.amount.mul(crfiPerLp).div(1e12).sub(user.crfiDebt).add(
            user.crfiTotal
        );
        reward = user.amount.mul(tokenPerLp).div(1e12).sub(user.tokenDebt).add(
            user.tokenTotal
        );
    }

    function updatePool(address token) public {
        PoolInfo storage pool = pools[token];
        if (block.number <= pool.lastBlock) {
            return;
        }
        if (pool.endBlock == 0) {
            pool.endBlock = block.number.add(pool.totalBlock);
        }
        if (pool.totalStake == 0) {
            pool.lastBlock = block.number;
            return;
        }
        uint256 multiplier = _getMultiplier(pool.endBlock, pool.lastBlock);
        uint256 rewardToken = multiplier.mul(pool.tokenPerBlock);
        uint256 rewardCRFI = multiplier.mul(pool.crfiPerBlock);
        pool.tokenPerLP = pool.tokenPerLP.add(
            rewardToken.mul(1e12).div(pool.totalStake)
        );
        pool.crfiPerLP = pool.crfiPerLP.add(
            rewardCRFI.mul(1e12).div(pool.totalStake)
        );
        pool.lastBlock = block.number;
        if (pool.lastBlock >= pool.endBlock) pool.isValid = false;
    }

    function _getMultiplier(uint256 endBlock, uint256 lastBlock)
        private
        view
        returns (uint256)
    {
        if (endBlock > block.number) {
            return block.number.sub(lastBlock);
        } else if (endBlock > lastBlock) {
            return endBlock.sub(lastBlock);
        } else {
            return 0;
        }
    }
}
