import "./ILPadICO.sol";

interface IBEP20 {
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom( address sender, address recipient, uint256 amount ) external returns (bool);
    function decimals() external view  returns (uint8);
}

contract LPadICOFactory is ILPadICO{
 // data storage
    struct ICOFactory {
       string TokenName;
        string TokenSymbol;
        string TokenIcon;
        string TokenFb;
        string TokenTwitter;
        string TokenWebsite;
        string TokenDescription;
        uint256 PresaleRate;
        uint256 SoftCap;
        uint256 HardCap;
        uint256 StartTime;
        uint256 EndTime;
        uint256 MinBuyRange;
        uint256 MaxBuyRange;
        address FactoryContract;
        address PayoutContractAddress;
        address IdoTokenContractAddress;
        address AddrOwnerMetamask;
        address IntractionContractAddr;
        bool WhiteListEnable;
        bool RefundTypeBurn;
        bool VestingEnable;
        }

    // store tokenAddress and intraction contract address
    address[]  IntractionContractAddr;


    // Creating mapping for ICOFactory data
    mapping (address => ICOFactory) ICODataset;


    ICOFactory[] ICOFactoryData;
    uint8 public idoCounter = 0;

    // function CollectIDOData(ConstructorParameters memory _params) public {
        function CollectIDOData(string[] memory _stringsList,uint256[] memory _numericList,address _AddrOwnerMetamask,address _IntractionContractAddr) public {



    // let _stringsList = [
    //   "TST",    //await getTokenName(data?.tokenAddress),
    //   "TST", // await getTokenSymbol(data?.tokenAddress),
    //   'https://www.pinksale.finance/static/media/ic-eth.9270fc02.svg',
    //    "https://google.com",
    //    "",
    //   "",
    //    "",
    // ];
            
           ICODataset[_IntractionContractAddr].TokenName = _stringsList[0]; 
           ICODataset[_IntractionContractAddr].TokenSymbol = _stringsList[1];// _stringsList.TokenSymbol; 
           ICODataset[_IntractionContractAddr].TokenIcon =  _stringsList[2]; //_stringsList.TokenIcon; 
           ICODataset[_IntractionContractAddr].TokenFb = _stringsList[3]; // _stringsList.TokenFb; 
           ICODataset[_IntractionContractAddr].TokenTwitter = _stringsList[4];//  _stringsList.TokenTwitter; 
           ICODataset[_IntractionContractAddr].TokenWebsite = _stringsList[5];// _stringsList.TokenWebsite; 
           ICODataset[_IntractionContractAddr].TokenDescription =_stringsList[6];//  _stringsList.TokenDescription; 
    // let _numericsList = ["5000000000000000000", "5000000000000000000", "10000000000000000000", "1648616285000000000000000000", "16496162085000000000000000000", "1000000000000000000", "10000000000000000000"];
// (7) ['1000000000000000000', '100000000000000000', '200000000000000000', '1666633674000000000000000000', '1667238478000000000000000000', '10000000000000000', '100000000000000000']
//{tokenAddress: '0x1e8602c1f08f8be3bec9de492140f2981ea35ee4', currency: '0x8301F2213c0eeD49a7E28Ae4c3e91722919B8B47', presaleRate: 1, refundType: 'refund', softCap: '0.1', …}

    // let _numericsList = [
    //   "1000000000000000000", //data?.presaleRate),
    //   "100000000000000000", //data?.softCap),
    //   "200000000000000000", //data?.hardCap),
    //   "1666633674000000000000000000", //startDate),
    //   "1667238478000000000000000000", //endDate),
    //   "10000000000000000", //data?.minBuy),
    //   "100000000000000000", //data?.maxBuy),
    // ];

    
        

           ICODataset[_IntractionContractAddr].PresaleRate =  _numericList[0]; // _numericList[.PresaleRate]; 
           ICODataset[_IntractionContractAddr].SoftCap = _numericList[1]; //_numericList.SoftCap; 
           ICODataset[_IntractionContractAddr].HardCap = _numericList[2]; // _numericList.HardCap; 
           ICODataset[_IntractionContractAddr].StartTime = _numericList[3]; //_numericList.StartTime; 
           ICODataset[_IntractionContractAddr].EndTime = _numericList[4]; //_numericList.EndTime; 
           ICODataset[_IntractionContractAddr].MinBuyRange = _numericList[5]; //_numericList.MinBuyRange; 
           ICODataset[_IntractionContractAddr].MaxBuyRange = _numericList[6]; //_numericList.MaxBuyRange; 

        //    ICODataset[_IntractionContractAddr].FactoryContract = _params.FactoryContract; 
        //    ICODataset[_IntractionContractAddr].PayoutContractAddress = _params.PayoutContractAddress; 
        //    ICODataset[_IntractionContractAddr].IdoTokenContractAddress = _params.IdoTokenContractAddress; 
            ICODataset[_IntractionContractAddr].AddrOwnerMetamask = _AddrOwnerMetamask; 
        //    ICODataset[_IntractionContractAddr].IntractionContractAddr = _IntractionContractAddr; 
           


        //    ICODataset[_IntractionContractAddr].WhiteListEnable = _params.WhiteListEnable; 
        //    ICODataset[_IntractionContractAddr].RefundTypeBurn = _params.RefundTypeBurn; 
        //    ICODataset[_IntractionContractAddr].VestingEnable = _params.VestingEnable; 

        IntractionContractAddr.push(_IntractionContractAddr);

        // Set data into Struct Type Array
        ICOFactoryData.push(getStructByAddress(IntractionContractAddr[idoCounter]));
        idoCounter++;
    }

    function getDataByAddressStr(address tokenAddr) public view returns(string memory,string memory,string memory,string memory,string memory,string memory,string memory) {
        return (
        ICODataset[tokenAddr].TokenName,
           ICODataset[tokenAddr].TokenSymbol,
           ICODataset[tokenAddr].TokenIcon,
           ICODataset[tokenAddr].TokenFb,
           ICODataset[tokenAddr].TokenTwitter,
           ICODataset[tokenAddr].TokenWebsite,
           ICODataset[tokenAddr].TokenDescription);
    }

function getDataByAddressNum(address tokenAddr) public view returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
        return (
           ICODataset[tokenAddr].PresaleRate,
           ICODataset[tokenAddr].SoftCap,
           ICODataset[tokenAddr].HardCap,
           ICODataset[tokenAddr].StartTime,
           ICODataset[tokenAddr].EndTime,
           ICODataset[tokenAddr].MinBuyRange,
           ICODataset[tokenAddr].MaxBuyRange );
        }


function getDataByAddressAddr(address tokenAddr) public view returns(address,address,address,address,address  ) {
        return (
           ICODataset[tokenAddr].FactoryContract ,
           ICODataset[tokenAddr].PayoutContractAddress ,
           ICODataset[tokenAddr].IdoTokenContractAddress,
           ICODataset[tokenAddr].AddrOwnerMetamask ,
           ICODataset[tokenAddr].IntractionContractAddr);
        
        }

function getDataByAddressBool(address tokenAddr) public view returns(bool ,bool ,bool) {
        return (
           ICODataset[tokenAddr].WhiteListEnable ,
           ICODataset[tokenAddr].RefundTypeBurn ,
           ICODataset[tokenAddr].VestingEnable
           );
        }


    function getStructByAddress(address _IntractionContractAddr) private view returns(ICOFactory memory){
        return ICODataset[_IntractionContractAddr];
    }


    
    function getIntractionAddrs() public view returns(address[] memory) {
        return IntractionContractAddr;
    }

    function getAllIntractionDetails() public view returns(ICOFactory[] memory) {
        return ICOFactoryData;
    }

    function getLastIDOContractAddress() public view returns(address) {
        require(idoCounter > 0, "IDO Not Created Yet");
        return IntractionContractAddr[IntractionContractAddr.length-1];
    }


    // Found Index of array 
    function getIndexValue(address[] memory _addrs, address _addr) private pure returns(bool, uint256) {
        for(uint256 i=0; i<_addrs.length; i++) {
            if(_addrs[i] == _addr){
                return (true, i);
            }
        }
        return (false, 0);
    }

    function getSocialMedia(address _interationAddr) public view returns(string memory, string memory, string memory, string memory, string memory, string memory, string memory){
        return (
        ICODataset[_interationAddr].TokenName,
           ICODataset[_interationAddr].TokenSymbol,
           ICODataset[_interationAddr].TokenIcon,
           ICODataset[_interationAddr].TokenFb,
           ICODataset[_interationAddr].TokenTwitter,
           ICODataset[_interationAddr].TokenWebsite,
           ICODataset[_interationAddr].TokenDescription);


    }



    // /****************************** Data Update Functions Starting ******************************/
    // // Change PresaleRate
    function setIDOPresaleRate(address __interationAddr, uint256 _price) public {
        ICODataset[__interationAddr].PresaleRate =_price;  // U1 -> 0 Means PresaleRate
        bool result;
        uint256 index;
        (result, index) = getIndexValue(IntractionContractAddr, __interationAddr);

        if (result==true){
            ICOFactoryData[index] = getStructByAddress(IntractionContractAddr[index]);
        }
    }





    //  // Change IDO SoftCap and HardCap
    function setIDOSoftHardCap(address __interationAddr, uint256 _softCap, uint256 _hardCap) public {
        ICODataset[__interationAddr].SoftCap =_softCap; // U1 -> 1 Means SoftCap
        ICODataset[__interationAddr].HardCap = _hardCap; // U1 -> 2 Means HardCap
        bool result;
        uint256 index;
        (result, index) = getIndexValue(IntractionContractAddr, __interationAddr);

        if (result==true){
            ICOFactoryData[index] = getStructByAddress(IntractionContractAddr[index]);
        }
    }


    // // Change IDO Min Max Buy Rnage
    function setIDOGlobalMinMaxBuy(address __interationAddr, uint256 _min, uint256 _max) public {
        ICODataset[__interationAddr].MinBuyRange = _min; // U1 -> 5 Min
        ICODataset[__interationAddr].MaxBuyRange = _max; // U1 -> 6 max
        bool result;
        uint256 index;
        (result, index) = getIndexValue(IntractionContractAddr, __interationAddr);

        if (result==true){
            ICOFactoryData[index] = getStructByAddress(IntractionContractAddr[index]);
        }
    }



    // // Change IDO Start Time and End Time
    function setIDOStartEndTime(address __interationAddr, uint256 _stime, uint256 _etime) public {
        ICODataset[__interationAddr].StartTime =_stime; // U1 -> 3 Means Start Time
        ICODataset[__interationAddr].EndTime = _etime; // U1 -> 4 Means End Time

        bool result;
        uint256 index;
        (result, index) = getIndexValue(IntractionContractAddr, __interationAddr);

        if (result==true){
            ICOFactoryData[index] = getStructByAddress(IntractionContractAddr[index]);
        }
    }


    // // Change IDO Start Time and End Time
    function setIDOBoolValues(address __interationAddr, bool _whiteList, bool _refundType, bool _vesting) public {
        ICODataset[__interationAddr].WhiteListEnable =_whiteList;
        ICODataset[__interationAddr].RefundTypeBurn = _refundType;
        ICODataset[__interationAddr].VestingEnable = _vesting;

        bool result;
        uint256 index;
        (result, index) = getIndexValue(IntractionContractAddr, __interationAddr);

        if (result==true){
            ICOFactoryData[index] = getStructByAddress(IntractionContractAddr[index]);
        }
    }




    // // Change socialMedia Data
    function setSocialMedia(address _interationAddr, string memory _ico, string memory _fb, string memory _twitter, string memory _website, string memory _desc) public {
        bytes memory _setIco = bytes(_ico);
        bytes memory _setFb = bytes(_fb);
        bytes memory _setTwitter = bytes(_twitter);
        bytes memory _setWebsite = bytes(_website);
        bytes memory _setDesc = bytes(_desc);


        if (_setIco.length != 0) {
            ICODataset[_interationAddr].TokenIcon = _ico; 
        }
        if (_setFb.length != 0) {
            ICODataset[_interationAddr].TokenFb = _fb; 
        }
        if (_setTwitter.length != 0) {
            ICODataset[_interationAddr].TokenTwitter = _twitter; 
        }

        if (_setWebsite.length != 0) {
            ICODataset[_interationAddr].TokenWebsite = _website; 
        }
        if (_setDesc.length != 0) {
            ICODataset[_interationAddr].TokenDescription = _desc; 
        }

        bool result;
        uint256 index;
        (result, index) = getIndexValue(IntractionContractAddr, _interationAddr);

        if (result==true){
            ICOFactoryData[index] = getStructByAddress(IntractionContractAddr[index]);
        }
    }
    
    /****************************** Data Update Functions Ending ******************************/

}


// String ["NAME","SMB", "ICON","FB", "TWITTER", "WEB", "Desc"]

// numeric [1,2,3,4,5,6,7,8,9]