
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Address.sol";
// import "@openzeppelin/contracts/security/ReentrancyGuard.sol";



import "./../Tokens/IBEP20.sol";
import "./ILPadBEP20Fact.sol";


contract LPadICOSale is Ownable {
    ILPadBEP20Fact factoryContract; // payout Token Object
    uint256 PresaleRate; // Sell PresaleRate (input PresaleRate should be multiply with 10 to the power decimalsValue)
    uint256 startTime; // IDO start time
    uint256 endTime; // IDO End Time
    uint256 minimumInvestment;  // minimum buy range for IDO
    uint256 maximumInvestment;  // maximum buy range for IDO
    uint256 softCap; // Soft Cap for the IDO
    uint256 hardCap; // Hard Cap for the IDo
    address idoTokenContractAddress; // ido Token Contract Address
    address payoutContractAddress; // payout Contract Address
    address[] _All_Investors_Addr; // Particepant's Addresses
    address AddrOwnerMetamask; // Owner Metamask Address
    uint256 spendTokens; // Total Fund
    uint256 collectedFund; // Total Collected payout Fund
    uint8 tokenDecimalDiff;
    bool is_sellStatus=true; // sale status on and off
    bool public isStakingRequired; // staking parameterss
    address public stakingContractAddress;
    bool public isVestingCalled;
    bool public loadFund;

    // dataset for tracking all the trades of the user
    struct SellTrackData {
        uint256 amount;
        bool isIDOTokenReceived;
        bool isRefundReceived;
    }
    
    address[]  SellTrackAddr; // capture all the addresses who perform trades
    uint256[]  SellTrackAddrAmount; // capture all the addresses amount who perform trades

    mapping(address => SellTrackData) public SellTrackDataset;



    address  FactoryContractAddress;

    // Constructor for the SaleIDOToken
    constructor(
        string[] memory _stringsList,
        uint256[] memory _numericsList,
        address _factotyContract,
        address _payoutContractAddress,
        address _idoTokenContractAddress,
        bool _isStakingRequired //IERC20Extented 
    ) {
        factoryContract = ILPadBEP20Fact(_factotyContract);
        FactoryContractAddress = _factotyContract;
        payoutContractAddress = _payoutContractAddress;
        idoTokenContractAddress = _idoTokenContractAddress;

        // fix these two items
        //_mint(_msgSender(), 10000 * (10 ** uint256(decimals())));
        
        // setting tokenDecimalDiff (from idoTokenContractAddress) has no issue.... reading it on payoutContract fails
        tokenDecimalDiff = IBEP20(idoTokenContractAddress).decimals(); // that said, should be fine with just using TokenContractAddress from contract itself
        //tokenDecimalDiff = IBEP20(payoutContractAddress).decimals() - IBEP20(idoTokenContractAddress).decimals();
        AddrOwnerMetamask = msg.sender;

        PresaleRate = _numericsList[0]; // 1 payout == 5 idoCoin
        softCap = _numericsList[1]; // In payout
        hardCap = _numericsList[2]; // In payout
        startTime = _numericsList[3] / 1e18;
        endTime = _numericsList[4] / 1e18;
        minimumInvestment = _numericsList[5];
        maximumInvestment = _numericsList[6];
        isStakingRequired = _isStakingRequired;

        factoryContract.CollectIDOData(_stringsList, _numericsList, AddrOwnerMetamask, address(this));
    }

// Load Fund
    function LoadFund(address _tokenAddr) public onlyOwner returns(bool){
        require(!loadFund, "Already Load fund to the ICo");
        // transfer Fund to the ICO.
        IBEP20(_tokenAddr).transferFrom(msg.sender, address(this), hardCap);
        loadFund = true;
        return true;
    }
    // 000000000000000000 999999999999999999
    function setStaking() public onlyOwner {
        if(isStakingRequired){
            isStakingRequired = false;
        }else{
            isStakingRequired = true;
        }
    }

    // SaleIDOToken function that will use to sell the ido Token
      
    function saleIDOToken(uint256 _payoutAmount) public  virtual returns (bool) {
        require((block.timestamp > startTime), "IDO Not Stated Yet");
        // Users can not invest after HardCap reached
        require(isHardCapReach() == false,"IDO Over, Our HardCap Already Reached.");
        require((block.timestamp < endTime), "IDO Sale Time Ended");

        require(collectedFund + _payoutAmount <= hardCap,"This Transaction may exceed IDO HardCap, Please try with lower _payoutAmount.");

        require(is_sellStatus == true, "Sale is Disabled by Admin.");

        // check max buy for the user
        require(minimumInvestment <= _payoutAmount, "This Amount is below the Minimux Buy range of this IDO");

        // check max buy for the user
        require(getUserInvestmentLimitLeft() >= _payoutAmount,"This Amount exceeding user allocation limit, Stake to get more allocaiton.");







        // set sell track after the transaction
        SetSellTrack(_payoutAmount);

        // Collect payoutToken only in this step
        IBEP20(payoutContractAddress).transferFrom(msg.sender, address(this), _payoutAmount);
        return true;
    }




    // balance of input address (idoCoin)
    function balanceOfIdoToken(address addr) public view returns (uint256) {
        return IBEP20(idoTokenContractAddress).balanceOf(addr);
    }


    // balance of input address (payoutCoin)
    function balanceOfpayoutToken(address addr) public view returns (uint256) {
        return IBEP20(payoutContractAddress).balanceOf(addr);
    }

    // Admin can Change sell status (0 to 1 and 1 to 0)
    function setIDOSaleStatus() public onlyOwner {
        if (is_sellStatus == true) {
            is_sellStatus = false;
        } else {
            is_sellStatus = true;
        }
    }

    // Anyone can check sell detial by passing address (Output : uint256)
    function getSellTrack(address _addr) private view returns (uint256) {
        return SellTrackDataset[_addr].amount;
    }


    // Admin can Change Start Time and End Time for IDO
    function setIDOTime(uint256 _startTime, uint256 _endTime) public onlyOwner {
        require(
            _endTime > _startTime,
            "Start Time Can not be Greater Than End Time"
        );

        startTime = _startTime / 1e18;
        endTime = _endTime / 1e18;

        // update in Factory Contract
        factoryContract.setIDOStartEndTime(address(this), _startTime, _endTime);
    }


    // Admin can set minimum and maximum buy range via this function 
    function setMinMaxBuyRange(uint256 _min, uint256 _max) public onlyOwner {
        minimumInvestment = _min;
        maximumInvestment = _max;

        // update in Factory Contract
        factoryContract.setIDOGlobalMinMaxBuy(address(this), _min, _max);
    }

    // List of all the particepants with their trade
    // Return two array first is the address of the trades and second is the amount list for that
    // Anyone can check All Trades
    function showAllTrade() public view returns (address[] memory, uint256[] memory)
    {
        return (SellTrackAddr, SellTrackAddrAmount);
    }


    // Admin can Refund their payout Currency to all clinets
    function Refund() public onlyOwner {
        require(SellTrackAddr.length > 0, "Transaction Not found to Refund");
        require(isSoftCapReach() == false,"IDO Status Pass, You Can not Refund");
        require(isSaleEnded(), "Wait for Sale End Time");
        require(!SellTrackDataset[msg.sender].isRefundReceived, "Already Got thier Tokens");

        IBEP20(payoutContractAddress).transfer(msg.sender, SellTrackDataset[msg.sender].amount);
        SellTrackDataset[msg.sender].isRefundReceived = true;
    }


    // Admin can change SoftCap and HardCap Amount
    function setSoftHardCap(uint256 _softCap, uint256 _hardCap) public onlyOwner {
        require(_hardCap > _softCap, "HardCap Must be Greater Than SoftCap.");
        require( _hardCap >= collectedFund, "HardCap Value Can not be less than Total Collected payout Fund." );

        softCap = _softCap;
        hardCap = _hardCap;

        // update in Factory Contract
        factoryContract.setIDOSoftHardCap(address(this), _softCap, _hardCap);
    }



    // Admin can change Token PresaleRate // argument -> 10**decimalsValue
    function setPresaleRate(uint256 _PresaleRate) public onlyOwner {
        require(block.timestamp < startTime,"Presale Price cannot be change after the start Time.");
        PresaleRate = _PresaleRate;

        // update in Factory Contract
        factoryContract.setIDOPresaleRate(address(this), _PresaleRate);
    }



    // Admin can Transfer all the Fund to Admin Address After IDO Completions
    function payoutTransferToAdmin() public onlyOwner returns (bool) {
        // 1. onlyOwner

        /* 2. Investors can only Claim after Sale End Time. */
        require(isSaleEnded(), "You cann't transfer fund before sale end.");

        // 3. SoftCap Reached
        require(isSoftCapReach() == true,"Soft Cap is not reached, IDO Failed");

        // payout fund transfer to owner or admin
        IBEP20(idoTokenContractAddress).transfer(AddrOwnerMetamask, collectedFund);

        return true;
    }

    

    // Anyone can check Soft Cap reached or not
    function isSoftCapReach() public view returns (bool) {
        // check soft cap
        if (collectedFund >= softCap) {
            return true;
        } else {
            return false;
        }
    }

    // Anyone can check Hard Cap reached or not
    function isHardCapReach() public view returns (bool) {
        // check hard cap
        if (collectedFund >= hardCap) {
            return true;
        } else {
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

    // It will mark entry in client SellTrack (it should be private)
    function SetSellTrack(uint256 _payoutAmount) private {

        // and capture transaction maker address into _All_Investors_Addr array
        // when address not present already
        if (isAddressInArray(_All_Investors_Addr, msg.sender) == false) {
            _All_Investors_Addr.push(msg.sender);
        }

        

        SellTrackDataset[msg.sender].amount = SafeMath.add(_payoutAmount, SellTrackDataset[msg.sender].amount);

        uint256 x = 0;
        for (uint256 i = 0; i < SellTrackAddr.length; i++) {
            if (SellTrackAddr[i] == msg.sender) {
                // address already present
                x = 1;

                // update SellTrackAddrAmount value when value already present
                SellTrackAddrAmount[i] = SafeMath.add(SellTrackAddrAmount[i], _payoutAmount);
            }
        }
        if (x == 0) {
            // address not present then insert
            SellTrackAddr.push(msg.sender);

            // When address not present or first entry then push amount at last place
            SellTrackAddrAmount.push(_payoutAmount);
        }

        // payoutCoin Fund Count Update
        spendTokens += (_payoutAmount * PresaleRate) / 1e18; 
        collectedFund += _payoutAmount;
    }





    // get view idoToken of the user
    function getClaimableToken(address _addr) public view returns (uint256) {
        return (SellTrackDataset[_addr].amount*PresaleRate)/1e18; // return Claimable amount of the investor
    }


    function isSaleEnded() public view returns (bool) {
        if ((collectedFund >= hardCap) || (block.timestamp >= endTime)) {
            return true;
        } else {
            return false;
        }
    }


    function fullVesting() public onlyOwner returns (bool) {
        /*1. After Sale End*/
        require(isSaleEnded(), "Sale is not Ended. Wait for it");
        require(!isVestingCalled, "Sale is not Ended. Wait for it");

        for(uint8 i=0; i<SellTrackAddr.length; i++) {

            /*2 Check whether User got their tokens or not*/
            if (!SellTrackDataset[SellTrackAddr[i]].isIDOTokenReceived){
                
                SellTrackDataset[SellTrackAddr[i]].isIDOTokenReceived = true;

                // Transfer Pending Fund to Investers address
                IBEP20(idoTokenContractAddress).transfer(SellTrackAddr[i], getClaimableToken(SellTrackAddr[i])/10**tokenDecimalDiff);
            }            
        }
        isVestingCalled = true;
        return true;
    }




    function claimToken() public returns (bool) {

        /*1. After Sale End*/
        require(isSaleEnded(), "Sale is not Ended. Wait for it");

        /*2. Check User has some pendings*/
        require(getClaimableToken(msg.sender)/10**tokenDecimalDiff > 0, "User does not have amount to calim.");

        /*3 Check whether User got their tokens or not*/
        require(!SellTrackDataset[msg.sender].isIDOTokenReceived, "User Already Got thier Token");

        /*4. IDO does not have token supply*/
        require(getClaimableToken(msg.sender)/10**tokenDecimalDiff <= IBEP20(idoTokenContractAddress).balanceOf(address(this)), "IDO does not have token supply");

        // Transfer Pending Fund to Investers address
        IBEP20(idoTokenContractAddress).transfer(msg.sender, getClaimableToken(msg.sender)/10**tokenDecimalDiff);
        
        SellTrackDataset[msg.sender].isIDOTokenReceived = true;

        return true;
    }


    function getTokenomics() public view returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint8, address, address) {
        return (PresaleRate, // 0 -> 5
        softCap, // 1 -> 5
        hardCap, // 2 -> 10
        startTime, // 3
        endTime, // 4
        minimumInvestment, // 5 -> 1
        maximumInvestment, // 6 -> 10
        spendTokens, // 7
        collectedFund, // 8
        tokenDecimalDiff, // 9
        payoutContractAddress, // 10
        idoTokenContractAddress);// 11
    }

    // allocation left of the user
    function getUserInvestmentLimitLeft() public view returns (uint256) {
        uint256 output;
        (, output) =  SafeMath.trySub(maximumInvestment, getSellTrack(msg.sender));
        return output;
    }


    // admin can retrieve any BEP20 Token via this function
    function retrieveStuckedBEP20Token(address _tokenAddr,uint256 amount,address toWallet) public onlyOwner returns(bool){
        IBEP20(_tokenAddr).transfer(toWallet, amount);
        return true;
    }

    // Update Social Media data 
    function updateSocialMedia(string memory _ico, string memory _fb, string memory _twitter, string memory _website, string memory _desc) public onlyOwner {
        // update in Factory Contract
        factoryContract.setSocialMedia(address(this), _ico, _fb, _twitter, _website, _desc);
    }


    function getSocialMediaData() public view returns(string memory, string memory, string memory, string memory, string memory, string memory, string memory){
        return ILPadBEP20Fact(FactoryContractAddress).getSocialMedia(address(this));
    }


    function setTokenContract(address _tokenContract) public onlyOwner{
        idoTokenContractAddress = _tokenContract;
        tokenDecimalDiff = IBEP20(payoutContractAddress).decimals() - IBEP20(_tokenContract).decimals();
        require(IBEP20(_tokenContract).decimals() <= 18, "Token Contract Decimal value Can Not be Greater than 18.");
    }


    function setStakingContract(address _stakingContract) external {
        stakingContractAddress = _stakingContract;
    }

    function getStakingData() public view returns(bool, address){
        return (isStakingRequired, stakingContractAddress);
    }
}

// ["NAME","SMB", "ICON","FB", "TWITTER", "WEB", "Desc"]
// ["5000000000000000000","5000000000000000000","10000000000000000000","1648616285000000000000000000","16496162085000000000000000000","1000000000000000000", "10000000000000000000"]
// 000000000000000000


// 0x0F11d3008cF5D8FF91F07aEBD71b0ecd502E5Fa3
// 0xF0d6E5354e84D441c0361ad11c5950a1EfF28BC3
// 0x50021f7e60caa0C25575c22D66CEEDdfF8BF8A35




//  ["1000000000000000000", '2000000000000000000', '4000000000000000000', '1665306636000000000000000000', '1665393039000000000000000000', '1000000000000000000', '3000000000000000000']
// '0xDF9eAd8681018242cc27Ac50ecC4b942E38AF87A' '0x46e4eFda2483aBd86E551c89B00E915EC3bfD0B0' false '0x13Df997cFB9B5Cb15c4C6f266e4d5A4a6Ca5Ff24' 
// ['USDT Token', 'TUSDT', '0x13Df997cFB9B5Cb15c4C6f266e4d5A4a6Ca5Ff24', '0x13Df997cFB9B5Cb15c4C6f266e4d5A4a6Ca5Ff24', '', '', '']


// ["Token_Ka_Name", "Symbol", "ICOn", "FB", "Twi__tter", "website link", "Description", "10000000000","10000000000","10000000000","10000000000","10000000000","10000000000","10000000000","0xd9145CCE52D386f254917e481eB44e9943F39138","0xf8e81D47203A594245E36C48e151709F0C19fBe8","0xf8e81D47203A594245E36C48e151709F0C19fBe8","0xf8e81D47203A594245E36C48e151709F0C19fBe8","0xf8e81D47203A594245E36C48e151709F0C19fBe8","true","true","true"]
