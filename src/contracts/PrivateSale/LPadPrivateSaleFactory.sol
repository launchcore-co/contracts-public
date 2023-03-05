import "./ILPadPrivateSaleFactory.sol";



contract LPadPrivateSaleFactory is ILPadPrivateSale{
    // data storage
    struct PrivateSaleFactory {
       string TokenName;
        string TokenSymbol;
        string AirdropTitle;
        string LogoURL;
        string Website;
        string Facebook;
        string Twitter;
        string Github;
        string Telegram;
        string Instagram;
        string Discord;
        string Reddit;
        string Description;
        uint256 StartTime;
        uint256 EndTime;
        uint256 SoftCap;
        uint256 HardCap;
        uint256 MinimumInvestment;
        uint256 MaximumInvestment;
        uint256 TGEPercentage;
        uint256 VestingCycle;
        uint256 VestingCyclePer;
        address FactoryContract;
        address TokenContractAddress;
        address OwnerAddress;
        bool WhiteListEnable;
        address PrivateSaleContractAddress;
        }

    // store tokenAddress and intraction contract address
    address[]  PrivateSaleContractAddressList;
    // Creating mapping for PrivateSaleFactory data
    mapping (address => PrivateSaleFactory) PrivateSaleDataset;

    PrivateSaleFactory[] PrivateSaleFactoryData;
    uint8 public privateSaleCounter = 0;

    function CollectPrivateSaleData(ConstructorParameters1 memory _params1, ConstructorParameters2 memory _params2, address _PrivateSaleContractAddress) public {
           PrivateSaleDataset[_PrivateSaleContractAddress].TokenName = _params1.TokenName; 
           PrivateSaleDataset[_PrivateSaleContractAddress].TokenSymbol = _params1.TokenSymbol; 
           PrivateSaleDataset[_PrivateSaleContractAddress].AirdropTitle = _params1.AirdropTitle; 
           PrivateSaleDataset[_PrivateSaleContractAddress].LogoURL = _params1.LogoURL; 
           PrivateSaleDataset[_PrivateSaleContractAddress].Website = _params1.Website; 
           PrivateSaleDataset[_PrivateSaleContractAddress].Facebook = _params1.Facebook; 
           PrivateSaleDataset[_PrivateSaleContractAddress].Twitter = _params1.Twitter; 
           PrivateSaleDataset[_PrivateSaleContractAddress].Github = _params1.Github; 
           PrivateSaleDataset[_PrivateSaleContractAddress].Telegram = _params1.Telegram; 
           PrivateSaleDataset[_PrivateSaleContractAddress].Instagram = _params1.Instagram; 
           PrivateSaleDataset[_PrivateSaleContractAddress].Discord = _params1.Discord; 
           PrivateSaleDataset[_PrivateSaleContractAddress].Reddit = _params1.Reddit; 
           PrivateSaleDataset[_PrivateSaleContractAddress].Description = _params1.Description; 

            
           PrivateSaleDataset[_PrivateSaleContractAddress].StartTime = _params2.StartTime; 
           PrivateSaleDataset[_PrivateSaleContractAddress].EndTime = _params2.EndTime; 
           PrivateSaleDataset[_PrivateSaleContractAddress].SoftCap = _params2.SoftCap; 
           PrivateSaleDataset[_PrivateSaleContractAddress].HardCap = _params2.HardCap; 
           PrivateSaleDataset[_PrivateSaleContractAddress].MinimumInvestment = _params2.MinimumInvestment; 
           PrivateSaleDataset[_PrivateSaleContractAddress].MaximumInvestment = _params2.MaximumInvestment; 
           PrivateSaleDataset[_PrivateSaleContractAddress].TGEPercentage = _params2.TGEPercentage; 
           PrivateSaleDataset[_PrivateSaleContractAddress].VestingCycle = _params2.VestingCycle; 
           PrivateSaleDataset[_PrivateSaleContractAddress].VestingCyclePer = _params2.VestingCyclePer; 
          
           PrivateSaleDataset[_PrivateSaleContractAddress].FactoryContract = _params2.FactoryContract; 
           PrivateSaleDataset[_PrivateSaleContractAddress].TokenContractAddress = _params2.TokenContractAddress; 
           PrivateSaleDataset[_PrivateSaleContractAddress].OwnerAddress = _params2.OwnerAddress; 
           PrivateSaleDataset[_PrivateSaleContractAddress].WhiteListEnable = _params2.WhiteListEnable; 
           PrivateSaleDataset[_PrivateSaleContractAddress].PrivateSaleContractAddress = _PrivateSaleContractAddress; 
           
        PrivateSaleContractAddressList.push(_PrivateSaleContractAddress);
        // Set data into Struct Type Array
        PrivateSaleFactoryData.push(getStructByAddress(PrivateSaleContractAddressList[privateSaleCounter]));
        privateSaleCounter++;
    }


    function getStructByAddress(address _PrivateSaleContractAddress) public view returns(PrivateSaleFactory memory){
        return PrivateSaleDataset[_PrivateSaleContractAddress];
    }

    function getAllAirdopAddresses() public view returns(address[] memory) {
        return PrivateSaleContractAddressList;
    }

    function getCompleteAirdopsDetails() public view returns(PrivateSaleFactory[] memory) {
        return PrivateSaleFactoryData;
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
}