import "./LPadStakingFactory.sol";





// Main Contract
contract LPadStaking  is ILPadStaking{

    event printMsg(string _printmsg);

    struct Stake {
        uint256 stackDuration;
        uint256 stackAmount;
        uint40 deposit_time;
        uint256 rewardPercent;
    }
    mapping(address => Stake) public stakersDataset;


    address  tokenAddr;
    uint256  penalityFees;
    mapping(uint8 => uint) stakingMaturityTime;
    mapping(uint8 => uint) apyPercent;
    uint256  tokenDecimal;
    address[]  stakedUsers;
    address public ownerAddr;
    uint8 public tokenDecimalDiff;
    uint256 public totalStaked;
    address public FactoryContractAddress;

    constructor(ConstructorParameters memory _params) {

        tokenDecimal = Token(_params.TokenContractAddress).decimals();
        require(tokenDecimal <= 18, "IDO Token decima more than 18 not allowed.");
        tokenAddr = _params.TokenContractAddress;
        ownerAddr = msg.sender;
        penalityFees = 3e18;
        stakingMaturityTime[1] = 15 days;
        stakingMaturityTime[2] = 30 days;
        stakingMaturityTime[3] = 90 days;
        stakingMaturityTime[4] = 180 days;

        apyPercent[1] = 2;
        apyPercent[2] = 5;
        apyPercent[3] = 20;
        apyPercent[4] = 50;
        tokenDecimalDiff = uint8(uint8(18) - Token(_params.TokenContractAddress).decimals());
        FactoryContractAddress = _params.FactoryContract; 
        LPadStakingFactory(_params.FactoryContract).CollectStakingData(_params, address(this));
    }



    function getAPY(uint256 _stakeAmount, uint8 _stakeDurationIndex) private  view returns(uint256 _apyIs) {
        return (apyPercent[_stakeDurationIndex]*_stakeAmount)/100;
    }


    /* Stake Token Function */
    function poolStake(uint256  _stakeAmount, uint8 _stakeDurationIndex) public returns (bool) {
        require(_stakeAmount/10**tokenDecimalDiff <= Token(tokenAddr).balanceOf(msg.sender),"Users does not have sufficeint tokens to stake");
        require(!isAlreadyStaked(msg.sender), "User has Already Staked");
        require(Token(tokenAddr).transferFrom(msg.sender, address(this), _stakeAmount/10**tokenDecimalDiff),"BEP20: Amount Transfer Failed Check if Amount is Approved");
        
        stakersDataset[msg.sender].stackDuration = stakingMaturityTime[_stakeDurationIndex];
        stakersDataset[msg.sender].stackAmount = _stakeAmount;
        stakersDataset[msg.sender].deposit_time = uint40(block.timestamp);
        stakersDataset[msg.sender].rewardPercent = getAPY(_stakeAmount, _stakeDurationIndex);
        totalStaked += _stakeAmount;


        if (!isAddressInArray(stakedUsers, msg.sender)) {
            stakedUsers.push(msg.sender);
        }

        return true;
    }


    // unstake pool 
    function unstake() public {
        require(isAlreadyStaked(msg.sender), "Users does not have amount to unstake");

        // check stake duration reach or not
        bool stakeDurationReached;
        if (block.timestamp >=  maturityDate(msg.sender)) {
                stakeDurationReached = true;
        }

        uint256 _principleAmount = stakersDataset[msg.sender].stackAmount;

        // if stake duration reach give rewardPercent otherwise apply panelty. 
        if(stakeDurationReached){
              // principle fund and rewardPercent
              emit printMsg("Principle fund + APY");
              
              uint256 _APYAmount = stakersDataset[msg.sender].rewardPercent;

              require(Token(tokenAddr).transfer(msg.sender, _principleAmount/10**tokenDecimalDiff),"BEP20: Principal Amount Transfer Failed");
              require(Token(tokenAddr).transfer(msg.sender, _APYAmount/10**tokenDecimalDiff),"BEP20: Reward Amount Transfer Failed");
            
        }else{
            // principle fund by applying panelty
            emit printMsg("Principle fund - Panelty");

            
            uint256 _finalAmount = _principleAmount - ((_principleAmount*penalityFees)/100)/1e18;

            require(Token(tokenAddr).transfer(msg.sender, _finalAmount/10**tokenDecimalDiff),"BEP20: Principal minus penality Amount Transfer Failed");
            
        }
        // Change in the data structre
        stakersDataset[msg.sender].stackDuration = 0;
        stakersDataset[msg.sender].stackAmount = 0;
        stakersDataset[msg.sender].deposit_time = 0;
        stakersDataset[msg.sender].rewardPercent = 0;

        // Minus from    totalStaked
        totalStaked -= _principleAmount;
    }

    function isAlreadyStaked(address _userAddr) public view returns(bool) {
        if (stakersDataset[_userAddr].stackAmount > 0){
            return true;
        }else{
            return false;
        }

    }


    // Check Address Present or not in given Address Array
    function isAddressInArray(address[] memory _addrArray, address _addr) private pure returns (bool) {
        bool tempbool = false;
        uint256 j = 0;
        while (j < _addrArray.length) {
            if (_addrArray[j] == _addr) {
                tempbool = true;
                break;
            }
            j++;
        }
        return tempbool;
    }


    function setMaturityTime(uint256 _maturityTime_1, uint256 _maturityTime_2, uint256 _maturityTime_3, uint256 _maturityTime_4) public  {
        require(msg.sender == ownerAddr, "Caller is not owner");
        stakingMaturityTime[1] = _maturityTime_1/1e18;
        stakingMaturityTime[2] = _maturityTime_2/1e18;
        stakingMaturityTime[3] = _maturityTime_3/1e18;
        stakingMaturityTime[4] = _maturityTime_4/1e18;
    }



    function setApyPercent(uint256 _apyPercent_1, uint256 _apyPercent_2, uint256 _apyPercent_3, uint256 _apyPercent_4) public   {
        require(msg.sender == ownerAddr, "Caller is not owner");
        apyPercent[1] = _apyPercent_1/1e18;
        apyPercent[2] = _apyPercent_2/1e18;
        apyPercent[3] = _apyPercent_3/1e18;
        apyPercent[4] = _apyPercent_4/1e18;
    }

    
    /* Check Token Balance inside Contract */
    function idoTokenBalance() public view returns (uint256){
        return Token(tokenAddr).balanceOf(address(this));
    }




    function retrieveBEP20TokenStuck(address _tokenAddr,uint256 amount,address toWallet) public returns(bool){
        require(msg.sender == ownerAddr, "Caller is not owner");
        Token(_tokenAddr).transfer(toWallet, amount/10**tokenDecimalDiff);
        return true;
    }


    /* Calculate Remaining PinkStaking Claim time of Users */
    function stakeTimeRemaining(address _userAdd) public view returns (uint256){
        if(stakersDataset[_userAdd].deposit_time > 0){
            uint256 stakeTime = stakersDataset[_userAdd].deposit_time + stakersDataset[_userAdd].stackDuration;
            if(stakeTime > block.timestamp){
                return (stakeTime - block.timestamp);
            }else{
                return 0;
            }
        }else{
            return 0;
        }
    }
    
    
    /* Maturity Date */
    function maturityDate(address _userAdd) public view returns(uint256){
        return (stakersDataset[_userAdd].deposit_time + stakersDataset[_userAdd].stackDuration);
    }
    
    function setTokenContract(address _tokenContract) public  {
        require(msg.sender == ownerAddr, "Caller is not owner");
        tokenAddr = _tokenContract;
    }

}