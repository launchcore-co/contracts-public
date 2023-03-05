
// SPDX-License-Identifier: MIT
import "./../SolidityVersion.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./LPadAirDropFactory.sol";
import "./ILPadAirdrop.sol";
import "./../Tokens/IBEP20.sol";



interface AirdopFactory is ILPadAirdrop {
    function CollectAirdopData(ConstructorParameters memory _params, address _AirdopContractAddress)  external;
}


contract LaunchPadAirDrop is Ownable, ILPadAirdrop {
        address tokenInstance;
    bool public isAirdropStart;
    bool public hasAirdropCancled;
    uint airdropStartTime;
    uint public TotalSumAllocation;
    mapping(address => uint) public userAllocation;
    address[]  users;
    uint[]  amounts;
    address public PINKSALE_OWNER = 0xADA301d3D1195f117153B32beF30BF4Ded2DBaE8;
    address public FactoryContractAddress;
  

  constructor(ConstructorParameters memory _params)  {
    FactoryContractAddress = _params.FactoryContract; 
    tokenInstance = _params.TokenContractAddress;
    AirdopFactory(_params.FactoryContract).CollectAirdopData(_params, address(this));
  }

//     constructor(address _tokenContract)  {
//     tokenInstance = _tokenContract;
//   }

    // remove all allocaiton 
    function removeAllAllocation() public onlyOwner {
        require(!isAirdropStart,"Airdop has started , so you can not Remove allocation");
        for(uint i=0; i<users.length; i++){
            users[i] = address(0);
            amounts[i] = 0;
            userAllocation[users[i]] = 0;
        }
        TotalSumAllocation = 0;
    }

    function getAllAllocations() public view returns(address[] memory, uint256[] memory){
        return(users, amounts);
    }



  function startAirdrop(uint _startTime)  onlyOwner  public {
    require(!hasAirdropCancled ,"Airdrop has cancled");
    require(!isAirdropStart,"Airdop Already Staerted.");
    require(TotalSumAllocation>0 ,"You dont have allocation users now.");
    airdropStartTime = _startTime;
    IBEP20(tokenInstance).transferFrom(msg.sender, PINKSALE_OWNER, TotalSumAllocation*10/100); 
    IBEP20(tokenInstance).transferFrom(msg.sender, address(this), TotalSumAllocation);
    isAirdropStart=true;

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

// If admin want to cancel Airdrop 
  function cancelAirdrop()  onlyOwner public {
    hasAirdropCancled=true;
    uint availableBalance;
    availableBalance =  IBEP20(tokenInstance).balanceOf(address(this));
    IBEP20(tokenInstance).transferFrom(msg.sender, address(this), availableBalance); 
  }


  // set Allocation of users in airdrop 
   function setAllocations(address[] memory addressList, uint[] memory amountList) onlyOwner public  {
       require(!hasAirdropCancled ,"Airdrop has cancled");
       require(!isAirdropStart,"Sale has started , so you can not add allocation");
        for (uint i = 0; i < amountList.length; i++) {
            userAllocation[addressList[i]] += amountList[i];
            TotalSumAllocation += amountList[i];

            (bool result, uint256 index) = isAddressInArray(users, addressList[i]);
            // address present 
            if(result){
                amounts[index] += amountList[i];
            }else{
                users.push(addressList[i]);
                amounts.push(amountList[i]);
            }
        }
    }



// set Vesting Function 
 function calimToken() public {
    require(block.timestamp >  airdropStartTime, "Airdop Time not started yet");
    require(isAirdropStart ,"Airdrop not start yet");
    uint256 balance = IBEP20(tokenInstance).balanceOf(address(this));
    require(balance>0 ,"Airdrop don't have token");
    uint256 getToken = userAllocation[msg.sender];
    require(getToken>0 ,"You don't have allocation");
    IBEP20(tokenInstance).transfer(msg.sender,getToken);
    userAllocation[msg.sender]=0;
    }
}


    // ["0x50021f7e60caa0C25575c22D66CEEDdfF8BF8A35","0xD14b1160Da6cb3D4963f48b25C596F007dc9aCf2"]
    // ["12000000000000000000","20000000000000000000"]
