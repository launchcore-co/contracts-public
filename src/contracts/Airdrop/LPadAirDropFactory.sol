// SPDX-License-Identifier: MIT
import "../SolidityVersion.sol";
import "./ILPadAirdrop.sol";


contract LPadAirDropFactory is ILPadAirdrop{
    // data storage
    struct AirdopFactory {
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
        uint256 TotalAllocation;
        uint256 TotalAllocation_10;
        address FactoryContract;
        address TokenContractAddress;
        address OwnerAddress;
        address AirdopContractAddress;
        }

    // store tokenAddress and intraction contract address
    address[]  AirdopContractAddressList;
    // Creating mapping for AirdopFactory data
    mapping (address => AirdopFactory) AirdopDataset;

    AirdopFactory[] AirdopFactoryData;
    uint8 public airdopCounter = 0;

    function CollectAirdopData(ConstructorParameters memory _params, address _AirdopContractAddress) public {
           AirdopDataset[_AirdopContractAddress].TokenName = _params.TokenName; 
           AirdopDataset[_AirdopContractAddress].TokenSymbol = _params.TokenSymbol; 
           AirdopDataset[_AirdopContractAddress].AirdropTitle = _params.AirdropTitle; 
           AirdopDataset[_AirdopContractAddress].LogoURL = _params.LogoURL; 
           AirdopDataset[_AirdopContractAddress].Website = _params.Website; 
           AirdopDataset[_AirdopContractAddress].Facebook = _params.Facebook; 
           AirdopDataset[_AirdopContractAddress].Twitter = _params.Twitter; 
           AirdopDataset[_AirdopContractAddress].Github = _params.Github; 
           AirdopDataset[_AirdopContractAddress].Telegram = _params.Telegram; 
           AirdopDataset[_AirdopContractAddress].Instagram = _params.Instagram; 
           AirdopDataset[_AirdopContractAddress].Discord = _params.Discord; 
           AirdopDataset[_AirdopContractAddress].Reddit = _params.Reddit; 
           AirdopDataset[_AirdopContractAddress].Description = _params.Description; 
            
           AirdopDataset[_AirdopContractAddress].StartTime = _params.StartTime; 
           AirdopDataset[_AirdopContractAddress].TotalAllocation = _params.TotalAllocation; 
           AirdopDataset[_AirdopContractAddress].TotalAllocation_10 = _params.TotalAllocation_10; 
           


           AirdopDataset[_AirdopContractAddress].FactoryContract = _params.FactoryContract; 
           AirdopDataset[_AirdopContractAddress].TokenContractAddress = _params.TokenContractAddress; 
           AirdopDataset[_AirdopContractAddress].OwnerAddress = _params.OwnerAddress; 
           AirdopDataset[_AirdopContractAddress].AirdopContractAddress = _AirdopContractAddress; 
           
        AirdopContractAddressList.push(_AirdopContractAddress);
        // Set data into Struct Type Array
        AirdopFactoryData.push(getStructByAddress(AirdopContractAddressList[airdopCounter]));
        airdopCounter++;
    }


    function getStructByAddress(address _AirdopContractAddress) public view returns(AirdopFactory memory){
        return AirdopDataset[_AirdopContractAddress];
    }

    function getAllAirdopAddresses() public view returns(address[] memory) {
        return AirdopContractAddressList;
    }

    function getCompleteAirdopsDetails() public view returns(AirdopFactory[] memory) {
        return AirdopFactoryData;
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

    // /****************************** Data Update Functions Starting ******************************/
    // // Change socialMedia Data
    // function setSocialMedia(address _airdropAddress, StringParameters memory _params
    // // string memory _airdopTitle,
    // // string memory _logoUrl, 
    // // string memory _website, 
    // // string memory _fb, 
    // // string memory _twitter, 
    // // string memory _github,
    // // string memory _telegram,
    // // string memory _insta,
    // // string memory _descord,
    // // string memory _reddit,
    // // string memory _desc
    // ) public {
    //     bytes memory _setAirdopTitle = bytes(_params.AirdropTitle);
    //     bytes memory _setLogoUrl = bytes(_params.LogoURL);
    //     bytes memory _setWebsite = bytes(_params.Website);
    //     bytes memory _setfb = bytes(_params.Facebook);
    //     bytes memory _setTwitter = bytes(_params.Twitter);
    //     bytes memory _setGithub = bytes(_params.Github);
    //     bytes memory _setTelegram = bytes(_params.Telegram);
    //     bytes memory _setInsta = bytes(_params.Instagram);
    //     bytes memory _setDescord = bytes(_params.Discord);
    //     bytes memory _setReddit = bytes(_params.Reddit);
    //     bytes memory _setDesc = bytes(_params.Description);

    //     if(_setAirdopTitle.length !=0 ){
    //         AirdopDataset[_airdropAddress].AirdropTitle = _params.AirdropTitle;
    //     }
    //     if(_setLogoUrl.length !=0 ){
    //         AirdopDataset[_airdropAddress].LogoURL = _params.LogoURL;
    //     }
    //     if (_setWebsite.length != 0) {
    //         AirdopDataset[_airdropAddress].Website = _params.Website; 
    //     }
    //     if (_setfb.length != 0) {
    //         AirdopDataset[_airdropAddress].Facebook = _params.Facebook; 
    //     }
    //     if (_setTwitter.length != 0) {
    //         AirdopDataset[_airdropAddress].Twitter = _params.Twitter; 
    //     }
    //     if (_setGithub.length != 0) {
    //         AirdopDataset[_airdropAddress].Github = _params.Github; 
    //     }
    //     if(_setTelegram.length != 0){
    //         AirdopDataset[_airdropAddress].Telegram = _params.Telegram;
    //     }
    //     if(_setInsta.length != 0){
    //         AirdopDataset[_airdropAddress].Instagram = _params.Instagram;
    //     }
    //     if(_setDescord.length != 0){
    //         AirdopDataset[_airdropAddress].Discord = _params.Discord;
    //     }
    //     if(_setReddit.length != 0){
    //         AirdopDataset[_airdropAddress].Reddit = _params.Reddit;
    //     }        
    //     if (_setDesc.length != 0) {
    //         AirdopDataset[_airdropAddress].Description = _params.Description; 
    //     }

    //     bool result;
    //     uint256 index;
    //     (result, index) = getIndexValue(AirdopContractAddressList, _airdropAddress);

    //     if (result==true){
    //         AirdopFactoryData[index] = getStructByAddress(AirdopContractAddressList[index]);
    //     }
    // }
    
    /****************************** Data Update Functions Ending ******************************/

}