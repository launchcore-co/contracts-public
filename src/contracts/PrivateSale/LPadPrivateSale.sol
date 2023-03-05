
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

import "./../Tokens/IBEP20.sol";
import "./ILPadPrivateSale.sol";
import "./ILPadPrivateSaleFactory.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract LPadPrivateSale is Ownable, ILPadPrivateSale {

    uint256 startTime; // private sale start time
    uint256 endTime; // private sale End Time
    uint256 minimumInvestment;  // minimum buy range for private sale
    uint256 maximumInvestment;  // maximum buy range for private sale
    uint256 softCap; // Soft Cap for the private sale
    uint256 hardCap; // Hard Cap for the private sale
    address tokenContractAddress; // Private Sale Token Contract Address
    uint256 TGEValue; // Amount first owner will get
    uint256 VestingCycle; // VestingCycle in minutes
    uint256 VestingCyclePer; // Vesting Cycle Percentage
    uint raisedFund; // Private Sale raised token
    uint totalAllocation;
    uint totalClaimedAllocation;
    bool isSaleFinalize;
    bool  isSaleCancel;
    uint8  tokenDecimal;
    address[] _All_Investors_Addr;
    address[]  SellTrackAddr;
    uint256[]  SellTrackAddrAmount;

    bool  whiteListEnable;
    address[] WhiteListUser;

    // vesting parameter
    uint  VestingStartTime;
    uint  totalCounter; 
    uint intervalAmount; 
    uint RemainingAmount; 
    bool  isFinalizaed;
    uint  alreadyClaimed;
    uint  currentCounterRunning;

    // dataset for tracking all the trades of the user
    struct SellTrackData {
        uint256 amount;
        bool isCancelSale;
    }
    mapping(address => SellTrackData) public SellTrackDataset;


    function getTokenomics256() public view returns(uint256 StartTime, uint256 EndTime, uint256 RaisedFund, uint256 SoftCap, uint256 HardCap, uint256 MinimumInvestment,uint256 MaximumInvestment, uint256 TokenDecimal){
        return(startTime, endTime, raisedFund, softCap, hardCap, minimumInvestment,maximumInvestment, tokenDecimal);
    }

    function getTokenomics() public view returns(address TokenContractAddress, uint256 tGEValue, uint256 vestingCycle, uint256 vestingCyclePer,uint TotalAllocation, uint TotalClaimedAllocation, bool IsSaleFinalize, uint8  TokenDecimal){
        return(tokenContractAddress, TGEValue, VestingCycle,  VestingCyclePer, totalAllocation, totalClaimedAllocation, isSaleFinalize, tokenDecimal);
    }
    function getTokenomicsVesting() public view returns( uint vestingStartTime,uint TotalCounter, uint IntervalAmount, 
    uint remainingAmount, bool IsFinalizaed,uint AlreadyClaimed,uint CurrentCounterRunning){
        return( VestingStartTime, totalCounter, intervalAmount, RemainingAmount, isFinalizaed, alreadyClaimed, currentCounterRunning); 
    }

    // Constructor for the private sale
    constructor(ConstructorParameters1 memory _params1, ConstructorParameters2 memory _params2){
        tokenDecimal = IBEP20(_params2.TokenContractAddress).decimals();
        startTime = _params2.StartTime/10**tokenDecimal;
        endTime = _params2.EndTime/10**tokenDecimal;
        tokenContractAddress = _params2.TokenContractAddress;
        minimumInvestment = _params2.MinimumInvestment ;
        maximumInvestment = _params2.MaximumInvestment;
        softCap = _params2.SoftCap;
        hardCap = _params2.HardCap;
        TGEValue = _params2.TGEPercentage/10**tokenDecimal;
        VestingCycle = (_params2.VestingCycle/10**tokenDecimal);
        VestingCyclePer = _params2.VestingCyclePer/10**tokenDecimal;
        whiteListEnable = _params2.WhiteListEnable;
        ILPadPrivateSaleFactory(_params2.FactoryContract).CollectPrivateSaleData(_params1, _params2, address(this));
    }

    
    

    // // Constructor for the private sale
    // constructor(
    //     uint256 _softCap,
    //     uint256 _hardCap,
    //     uint256 _minimumInvestment,
    //     uint256 _maximumInvestment,
    //     uint256 _startTime,
    //     uint256 _endTime,
    //     uint256 _TGEValue,uint256 _VestingCycle, uint256 _VestingCyclePer,
    //     bool _whiteListEnable,
    //     address _tokenContractAddress
    // ){
    //     tokenDecimal = IBEP20(_tokenContractAddress).decimals();
    //     startTime=_startTime/10**tokenDecimal;
    //     endTime=_endTime/10**tokenDecimal;
    //     tokenContractAddress =_tokenContractAddress;
    //     minimumInvestment=_minimumInvestment;
    //     maximumInvestment = _maximumInvestment;        
    //     softCap = _softCap;
    //     hardCap = _hardCap;
    //     TGEValue = _TGEValue/10**tokenDecimal;
    //     VestingCycle = (_VestingCycle/10**tokenDecimal);
    //     VestingCyclePer = _VestingCyclePer/10**tokenDecimal;
    //     whiteListEnable = _whiteListEnable;
    // }
    
     // Finalize 
    function Finalized() public onlyOwner{
        require(!isSaleFinalize, "Already Finalized");
        isFinalizaed = true;
        uint  InitialAmount = IBEP20(tokenContractAddress).balanceOf(address(this)); ///10*1e18;
        isSaleFinalize = true;
        VestingStartTime = block.timestamp;
        IBEP20(tokenContractAddress).transfer(msg.sender, (InitialAmount*TGEValue)/100);
        intervalAmount  = (InitialAmount * VestingCyclePer)/100; 
        RemainingAmount = ((100 - TGEValue)*InitialAmount)/100; 
        totalCounter = ((100-TGEValue)/VestingCyclePer); // 3 round
    }

    // 8. Emergenry Withdraw (10%)
    function EmergenryWithdraw() public returns(bool) {
        (bool result, uint256 index) = isAddressInArray(_All_Investors_Addr, msg.sender);
        require(!isSaleEnd(), "can not withdraw after sale end");
        require(result, "User not invested in private sale");
        uint256 userInvestAmount = SellTrackDataset[msg.sender].amount;
        require(userInvestAmount > 0, "Zero Invest Amount");
        // transfer token to the user 
        IBEP20(tokenContractAddress).transfer(msg.sender, (userInvestAmount*90)/100); 
        SellTrackDataset[msg.sender].amount = 0;
        SellTrackAddrAmount[index] = 0;
        SellTrackDataset[msg.sender].isCancelSale = true;
        return true;
    }


    // Cancel Pool (Admin Funciton)
    function cancelPool() public onlyOwner returns(bool) {
        require(isSaleEnd(), "Pool can be cancel after the sale end");
        isSaleCancel = true;
        for (uint256 i = 0; i < _All_Investors_Addr.length; i++) {
            IBEP20(tokenContractAddress).transfer(_All_Investors_Addr[i], SellTrackAddrAmount[i]);
        }
        return true;
    }


    // Private Sale Buy Function 
    function Buy(uint256 _busdAmount) public returns (bool) {
        require(!isSaleCancel, "Sale canceld by admin");
        require(!isSaleEnd(), "Ico is over");
     
        require(block.timestamp >= startTime, "ICO Sale not started yet");
        if(whiteListEnable){
            require(verifyUser(msg.sender),"User is not whitelisted");
        }
        // require(false, "KULDEPP ji yha kskf sk k ks ");
        require(_busdAmount >= minimumInvestment, "User can not invest below the minimum investment!");
        // check max buy for the user
        require(getUserAllocationLeft() >= _busdAmount,"This Amount exceeding user allocation limit.");
        require(raisedFund + _busdAmount <= hardCap,"This Transaction may exceed private sale Hardcap limit.");
        // require(false, "KULDEPP ji yha kskf sk k ks ");
        // Collect BUSD to ICO Contract Address
        IBEP20(tokenContractAddress).transferFrom(msg.sender, address(this), _busdAmount);
        // set sell track after the transaction
        
        SetSellTrack(_busdAmount);
        return true;
    }


// It will mark entry in client SellTrack (it should be private)
    function SetSellTrack(uint256 _busdAmount) private {

        // and capture transaction maker address into _All_Investors_Addr array
        // when address not present already
        (bool result, ) = isAddressInArray(_All_Investors_Addr, msg.sender);
        if (result == false) {
            _All_Investors_Addr.push(msg.sender);
        }

        SellTrackDataset[msg.sender].amount = _busdAmount + SellTrackDataset[msg.sender].amount;

        uint256 x = 0;
        for (uint256 i = 0; i < SellTrackAddr.length; i++) {
            if (SellTrackAddr[i] == msg.sender) {
                // address already present
                x = 1;

                // update SellTrackAddrAmount value when value already present
                SellTrackAddrAmount[i] = SellTrackAddrAmount[i] + _busdAmount;
            }
        }
        if (x == 0) {
            // address not present then insert
            SellTrackAddr.push(msg.sender);

            // When address not present or first entry then push amount at last place
            SellTrackAddrAmount.push(_busdAmount);
        }


        // busdCoin Fund Count Update 
        raisedFund = raisedFund + _busdAmount;
    }

    // admin can whitelist users
     function retrieveStuckedERC20Token(address _tokenAddr, uint256 _amount, address _toWallet) public onlyOwner returns(bool){
        IBEP20(_tokenAddr).transfer(_toWallet, _amount);
        return true;
    }

    // Enable or disable Whitelist paramerter
    function setWhiteList() public onlyOwner{
         if (whiteListEnable == true){
            whiteListEnable = false;
        }else{
            whiteListEnable = true;
        }
    }

    function isSaleEnd() public view returns (bool) {
        if ((block.timestamp >= endTime || (raisedFund >= hardCap))){
            return true;
        } else {
            return false;
        }
    }

    
    // Anyone can check sell detial by passing address (Output : uint256)
    function getSellTrack(address _addr) public view returns (uint256) {
        return SellTrackDataset[_addr].amount;
    }


    // allocation left of the user
    function getUserAllocationLeft() public view returns (uint256) {
        ( , uint256 result) = SafeMath.trySub(maximumInvestment , getSellTrack(msg.sender));
            return result;
    }


    function isSoftCapReached() public view returns (bool) {
        if (raisedFund >= softCap){
            return true;
        } else {
            return false;
        }
    }

    function isHardCapReached() public view returns (bool) {
        if (raisedFund >= hardCap){
            return true;
        } else {
            return false;
        }
    }    


   function addBulkUsers(address[] memory _addressToWhitelist) public onlyOwner {
        for(uint8 i=0;i<_addressToWhitelist.length;i++){
            (bool result, ) = isAddressInArray(WhiteListUser, _addressToWhitelist[i]);
            if(!result){
            WhiteListUser.push(_addressToWhitelist[i]);
            } 
        }
    }

    function verifyUser(address _whitelistedAddress) public view returns(bool) {
        (bool result, ) = (isAddressInArray(WhiteListUser, _whitelistedAddress));
        return result;
    }

     // Admin can remove individual Whitelisted User, and MaxBuy autometically set to 0
    function RemoveWhiteListed(address _addr) public onlyOwner {
        (bool result, ) = isAddressInArray(WhiteListUser, _addr);
        require(result, "This Address not present into Whitelist Users list.");

        // put address zero when address found
        for (uint256 i = 0; i < WhiteListUser.length; i++) {
            if (WhiteListUser[i] == _addr) {
                WhiteListUser[i] = address(0);
            }
        }
    }
    



    // claim token only owner have right to access.
    function claimToken() public onlyOwner {
        IBEP20(tokenContractAddress).transfer(msg.sender,(totalAllocation * TGEValue)/100);
        totalClaimedAllocation+=(totalAllocation * TGEValue)/100;
    }


    function youCanClaim() public returns(uint Counter, uint EachInterval, uint Claimed,uint Available, uint CurrentRountClaim) {
        uint claimThisRound; uint currentCounter; uint claimAmount; uint finalAmount;
        require(isFinalizaed, "Sale not finalized");
        currentCounter = (block.timestamp - VestingStartTime)/VestingCycle;
        if(currentCounterRunning != 0){
            require(currentCounterRunning != currentCounter, "Wait for next round");
        }
        if (currentCounter > totalCounter){
            currentCounter = totalCounter;
        }
        claimAmount = (currentCounter) * intervalAmount;
        finalAmount = RemainingAmount - claimAmount;
        claimThisRound = claimAmount - alreadyClaimed;
        alreadyClaimed += claimThisRound;
        currentCounterRunning = currentCounter;
        IBEP20(tokenContractAddress).transfer(msg.sender, claimThisRound);
        //require(claimThisRound==0, "Wait for 6o second");
        return (currentCounter,intervalAmount, claimAmount,finalAmount, claimThisRound); 
    }

        // Check Address Present or not in given Address Array
    function isAddressInArray(address[] memory _addrArray, address _addr) private pure returns (bool, uint256) {
        bool result = false;
        uint256 index = 0;
        while (index < _addrArray.length) {
            if (_addrArray[index] == _addr) {
                result = true;
                break;
            }
            index++;
        }
        return (result, index);
    }
}

// 10000000000000000000
// 100000000000000000000
// 1000000000000000000
// 10000000000000000000
// 1665308569000000000000000000
// 1668308569000000000000000000
// 40000000000000000000
// 20000000000000000000
// 10000000000000000000
// true
// address


// 1. Whitelist enable or disable
// 2. SoftCap and hardCap
// 3. Min & max buy
// 4. Start Time and End Time
// 5. First Fund Release For Project (%)* - 40%
// 6. Fund Vesting Period Each Cycle (minutes)* - 3 minutes
// 7. Fund Release Each Cycle (percent)* - 20%
// 8. Emergenry Withdraw (10%)
// 9. Cancel Pool (admin sale end k baad kabhi bhi call kr skta hai)
// 10. Finalize (transfer colleced fund to the owner) and sale end and tokens avialale to the users
// 11. getTokenomics
