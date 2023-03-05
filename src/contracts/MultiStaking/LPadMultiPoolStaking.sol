
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "./LPadPoolStakingRequirements.sol";
import "./../Uniswap/v2/interfaces/IUniswapV2Router02.sol";



contract LPadMultiPoolStaking is Auth {
    using SafeMath for uint256;

    struct PoolInfo {
        address rewardToken;
        uint256 rewardPerBlock;
        uint256 lockTime;
        bool sell;
        bool isPaused;
    }

    struct StakingInfo {
        address nftAddress;
        uint256 tokenId;
        uint256 startBlock;
    }

    IUniswapV2Router02 public uniswapV2Router;
    address public mainToken;

    mapping(uint256 => mapping(address => StakingInfo[])) public userInfos;

    PoolInfo[] public poolInfos;
    uint256 public stakingFee = 1500000 ether;
    uint256 public claimFee = 2;

    event Stake(uint256 pid, address indexed user, address indexed nftAddress, uint256 tokenId);
    event UnStake(uint256 pid, address indexed user, address indexed nftAddress, uint256 tokenId);

    constructor() {
        // IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x83f465457c8caFbe85aBB941F20291F826C7F72A);
        // uniswapV2Router = _uniswapV2Router;
        // mainToken = 0xe6F2c07942DA91134138041e6391E8457274E456;
    }

    function add(address _rewardTokenAddress, uint256 _rewardPerBlock, uint256 _lockTime, bool _sellable) public authorized {
        PoolInfo memory pool;
        pool.rewardToken = _rewardTokenAddress;
        pool.rewardPerBlock = _rewardPerBlock;
        pool.lockTime = _lockTime;
        pool.sell = _sellable;
        pool.isPaused = false;
        poolInfos.push(pool);
    }

    function changeRewardTokenAddress(uint256 _pid, address _rewardTokenAddress) public authorized {
        PoolInfo storage pool = poolInfos[_pid];
        pool.rewardToken = _rewardTokenAddress;
    }

    function changeRewardTokenPerDay(uint256 _pid, uint256 _rewardPerBlock) public authorized {
        PoolInfo storage pool = poolInfos[_pid];
        pool.rewardPerBlock = _rewardPerBlock;
    }

    function changeLockTime(uint256 _pid, uint256 _lockTime) public authorized {
        PoolInfo storage pool = poolInfos[_pid];
        pool.lockTime = _lockTime;
    }

    function changePoolInfoSell(uint256 _pid, bool _sell) public authorized {
        PoolInfo storage pool = poolInfos[_pid];
        pool.sell = _sell;
    }

    function setPoolPaused(uint256 _pid, bool _isPaused) public authorized {
        PoolInfo storage pool = poolInfos[_pid];
        pool.isPaused = _isPaused;
    }

    function pendingReward(uint256 _pid,  address _user, address _nftAddress,  uint256 _tokenId) public view returns (uint256) {
        PoolInfo storage pool = poolInfos[_pid];
        (bool _isStaked, uint256 _startBlock) = getStakingItemInfo(_pid, _user, _nftAddress, _tokenId);
        
        if (!_isStaked) {
            return 0;
        }
        
        uint256 currentBlock = block.timestamp;
        uint256 rewardAmount;
        if (currentBlock.sub(_startBlock) > pool.lockTime) {
            rewardAmount = (currentBlock.sub(_startBlock)).mul(pool.rewardPerBlock);
        } else {
            rewardAmount = (currentBlock.sub(_startBlock)).mul(pool.rewardPerBlock).div(2);
        }
        return rewardAmount;
    }

    function pendingTotalReward(uint256 _pid,  address _user) public view returns(uint256) {
        uint256 pending = 0;

        for (uint256 i = 0; i < userInfos[_pid][_user].length; i++) {
            uint256 temp = pendingReward(_pid, _user, userInfos[_pid][_user][i].nftAddress, userInfos[_pid][_user][i].tokenId);
            pending = pending.add(temp);
        }

        return pending;
    }

    function swapETHForToken(address _token) internal {
        address[] memory path = new address[](2);
        path[0] = uniswapV2Router.WETH();
        path[1] = _token;
        uniswapV2Router.swapETHForExactTokens(0, path, address(this), block.timestamp);
    }

    function setStakingFee(uint256 _newFee) external authorized {
        stakingFee = _newFee;
    } 

    function setMainToken(address _address) external authorized {
        mainToken = _address;
    }

    function stake(uint256 _pid, address _nftAddress, uint256[] memory tokenIds) public payable{
        PoolInfo storage pool = poolInfos[_pid];
        require(pool.isPaused == false, "Cannot stake to this pool.");
        require(msg.value >= stakingFee, "Need to pay fee");
        require(pool.rewardToken != address(0x0), "No Pool Info");

        address[] memory path = new address[](2);
        path[0] = uniswapV2Router.WETH();
        path[1] = address(mainToken);
        uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: msg.value}(0, path, address(this), block.timestamp.add(300));

        for (uint256 i = 0; i < tokenIds.length; i++) {
            (bool _isStaked,) = getStakingItemInfo(_pid, msg.sender, _nftAddress, tokenIds[i]);

            if (_isStaked) {
                continue;
            }

            if (IERC721(_nftAddress).ownerOf(tokenIds[i]) != msg.sender) {
                continue;
            }
            
            if (pool.sell) {
                IERC721(_nftAddress).transferFrom(address(msg.sender), address(this), tokenIds[i]);
            }

            StakingInfo memory info;
            info.tokenId = tokenIds[i];
            info.startBlock = block.timestamp;
            info.nftAddress = _nftAddress;

            userInfos[_pid][msg.sender].push(info);
            emit Stake(_pid, msg.sender, _nftAddress, tokenIds[i]);
        }
    }

    function unstake(uint256 _pid, address _nftAddress, uint256[] memory tokenIds) public {
        PoolInfo storage pool = poolInfos[_pid];
        uint256 pending = 0;

        for (uint256 i = 0; i < tokenIds.length; i++) {
            (bool _isStaked,) = getStakingItemInfo(_pid, msg.sender, _nftAddress, tokenIds[i]);
            
            if (!_isStaked) {
                continue;
            }

            if (pool.sell && IERC721(_nftAddress).ownerOf(tokenIds[i]) != address(this)) {
                continue;
            }

            uint256 temp = pendingReward(_pid, msg.sender, _nftAddress, tokenIds[i]);
            pending = pending.add(temp);
            
            removeFromStakingInfo(_pid, msg.sender, _nftAddress, tokenIds[i]);
            
            if (pool.sell) {
                IERC721(_nftAddress).transferFrom(address(this), msg.sender, tokenIds[i]);
            }
            emit UnStake(_pid, msg.sender, _nftAddress, tokenIds[i]);
        }

        if (pending > 0 && IERC20(pool.rewardToken).balanceOf(address(this)) >= pending) {
            IERC20(pool.rewardToken).transfer(msg.sender, pending);
        }
    }

    function getStakingItemInfo(uint256 _pid, address _user, address _nftAddress, uint256 _tokenId) public view returns(bool _isStaked, uint256 _startBlock) {
        for (uint256 i = 0; i < userInfos[_pid][_user].length; i++) {
            if (userInfos[_pid][_user][i].tokenId == _tokenId && userInfos[_pid][_user][i].nftAddress == _nftAddress) {
                _isStaked = true;
                _startBlock = userInfos[_pid][_user][i].startBlock;
                break;
            }
        }
    }

    function removeFromStakingInfo(uint256 _pid, address _user, address _nftAddress, uint256 tokenId) private {        
        for (uint256 i = 0; i < userInfos[_pid][msg.sender].length; i++) {
            if (userInfos[_pid][_user][i].tokenId == tokenId && userInfos[_pid][_user][i].nftAddress == _nftAddress) {
                userInfos[_pid][_user][i] = userInfos[_pid][_user][userInfos[_pid][_user].length - 1];
                userInfos[_pid][_user].pop();
                break;
            }
        }
    }

    function getUserInfo(uint256 _pid, address _user) public view returns (StakingInfo[] memory) {
        uint256 _itemCount = userInfos[_pid][_user].length;
        StakingInfo[] memory _stakingInfo = new StakingInfo[](_itemCount);
        for(uint256 i = 0; i < _itemCount;i++) {
            _stakingInfo[i] = userInfos[_pid][_user][i];
        }
        return _stakingInfo;
    }

    function setClaimFee(uint256 _newFee) external authorized {
        claimFee = _newFee;
    }

    function claim(uint256 _pid) public {
        PoolInfo storage pool = poolInfos[_pid];
        uint256 reward = pendingTotalReward(_pid, msg.sender) * (100 - claimFee) / 100;

        for (uint256 i = 0; i < userInfos[_pid][msg.sender].length; i++) {
            userInfos[_pid][msg.sender][i].startBlock = block.timestamp;
        }

        IERC20(pool.rewardToken).transfer(msg.sender, reward);
    }

    function claimAll() public {
        for(uint256 i = 0;i<poolInfos.length;i++) {
            claim(i);
        }
    }

    receive() external payable { }

    function emergencyWithdrawToken(uint256 _pid, uint256 _amount) external authorized {
        PoolInfo memory pool = poolInfos[_pid];
        IERC20(pool.rewardToken).transfer(msg.sender, _amount);
    }

    function emergencyWithdraw(uint256 amount) external authorized {
        uint256 balance = address(this).balance;
        require(amount > 0 && amount <= balance, "Cannot withdraw");
        (bool success, ) = (msg.sender).call{value: amount}("");
        require(success, "Withdraw failed!");
    }
}
