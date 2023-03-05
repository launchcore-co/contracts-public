import "./ILPadStaking.sol";
import "./IToken.sol";

contract LPadStakingFactory is ILPadStaking {
    // data storage
    struct StakingFactory {
       string TokenName;
        string TokenSymbol;
        string StakingTitle;
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
        address FactoryContract;
        address TokenContractAddress;
        address OwnerAddress;
        address StakingContractAddress;
    }

    // store tokenAddress and intraction contract address
    address[]  StakingContractAddressList;
    // Creating mapping for StakingFactory data
    mapping (address => StakingFactory) StakingDataset;

    StakingFactory[] StakingFactoryData;
    uint8 public stakeingCounter = 0;

    function CollectStakingData(ConstructorParameters memory _params, address _StakingContractAddress) public {
           StakingDataset[_StakingContractAddress].TokenName = _params.TokenName; 
           StakingDataset[_StakingContractAddress].TokenSymbol = _params.TokenSymbol; 
           StakingDataset[_StakingContractAddress].StakingTitle = _params.StakingTitle; 
           StakingDataset[_StakingContractAddress].LogoURL = _params.LogoURL; 
           StakingDataset[_StakingContractAddress].Website = _params.Website; 
           StakingDataset[_StakingContractAddress].Facebook = _params.Facebook; 
           StakingDataset[_StakingContractAddress].Twitter = _params.Twitter; 
           StakingDataset[_StakingContractAddress].Github = _params.Github; 
           StakingDataset[_StakingContractAddress].Telegram = _params.Telegram; 
           StakingDataset[_StakingContractAddress].Instagram = _params.Instagram; 
           StakingDataset[_StakingContractAddress].Discord = _params.Discord; 
           StakingDataset[_StakingContractAddress].Reddit = _params.Reddit; 
           StakingDataset[_StakingContractAddress].Description = _params.Description; 
            
           StakingDataset[_StakingContractAddress].StartTime = _params.StartTime; 

           StakingDataset[_StakingContractAddress].FactoryContract = _params.FactoryContract; 
           StakingDataset[_StakingContractAddress].TokenContractAddress = _params.TokenContractAddress; 
           StakingDataset[_StakingContractAddress].OwnerAddress = _params.OwnerAddress; 
            StakingDataset[_StakingContractAddress].StakingContractAddress = _StakingContractAddress; 


        StakingContractAddressList.push(_StakingContractAddress);
        // Set data into Struct Type Array
        StakingFactoryData.push(getStructByAddress(StakingContractAddressList[stakeingCounter]));
        stakeingCounter++;
    }


    function getStructByAddress(address _StakingContractAddress) public view returns(StakingFactory memory){
        return StakingDataset[_StakingContractAddress];
    }

    function getAllStakingAddresses() public view returns(address[] memory) {
        return StakingContractAddressList;
    }

    function getCompleteStakingDetails() public view returns(StakingFactory[] memory) {
        return StakingFactoryData;
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