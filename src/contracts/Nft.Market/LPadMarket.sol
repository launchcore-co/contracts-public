// Created by Bansclaw
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

// please note, to use upgradeable,  you have to have all contracts you are attempting to use
// for assistance in order to get what you need
// import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
// import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";
// import "@openzeppelin/contracts/security/Pausable.sol";

// import "@openzeppelin/contracts/utils/Strings.sol";
// import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
// import "@openzeppelin/contracts/access/AccessControl.sol";

import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/extensions/ERC1155BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/extensions/ERC1155SupplyUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/extensions/ERC1155PausableUpgradeable.sol";


contract BansclawNftMarket is Initializable, ERC1155Upgradeable,ERC1155BurnableUpgradeable, OwnableUpgradeable , ERC1155PausableUpgradeable, ERC1155SupplyUpgradeable, 
AccessControlUpgradeable, ReentrancyGuardUpgradeable  {
    // Create a new role identifier for the minter role
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");

    // You can change this to your own collection name
    string public constant name = "LPad Nft Market";
    
    // You can change this to your own collection symbol
    string public constant symbol = "LPNFTM";

    // Mapping from token ID to IPFS hash
    mapping (uint256 => string) private _tokenURIs;

    // *** [🛑 CLASSES AND RARITY] ********************************************************************************************************************************
    

    // *** [🟢 FUNDS DISTRIBUTION ] ********************************************************************************************************************************

    address private LPAD_WALLET_STORE_ADDRESS = 0xbDF7604279A31e4779BD0b895a2304aD0eF32157;

    uint256 public tokenId;
    uint256 public txAuditCnt;
    uint256 public categoryId;
    
    // *** [🛑 FUNDS DISTRIBUTION ] ********************************************************************************************************************************
    //mapping(address => uint) public balances;
    uint balances;
    uint dispersed;


    enum TxType{ MINT, TRANSFER, NA }
    struct TxDetails {
        TxType txType;
        address from;
        address to;
        uint tokenId;
        uint amount;
    }

    /*
    * @dev Struct structure and mapping
    */
    struct Struct {
        // address addr;
        uint tokenId;
        
        uint catIdTokId;
        uint catId;
        uint decimals;
        uint cost;

        address author;
        string name;
        string desc;
        string ipfs; 
        uint supply;

       uint createdAt;
        
        uint startsAt;
        uint endsAt;
        uint itemsSold;

        bool paused;
        bool soldOut;
        bool purchasable;
        bool airdrop;
    }

    struct CategoryStruct {
        uint categoryId;
        string name;
        
        string desc;
        uint createdAt;
        
    }

    mapping(uint256 => TxDetails) public txAuditDetails;

    // keep track of each type of categories to map
    mapping(uint256 => CategoryStruct) public categoryStructs;

    // mapping categories/structure in order to do multi-array mapping
    mapping (uint256 => mapping (uint256 => Struct)) internal structs;

    // keep track of total structure (this way, we can retrieve the count for each category)
    mapping (uint256 => uint256) public totalStructs;

    /*
    * emit event log to specify a mint file was set
    */
    event MintEmit(address to, uint256 id, uint256 amount);
    /*
    * emit event log to specify a burnmint
    */
    event MintBurnEmit(address from, uint256 id, uint256 amount);
    

    /*
    * emit event log to specify a mint file was set
    */
    //event CreateNftItem(address sender, uint256 categoryId, uint256 catTokenid, uint256 tokenId, string name, uint256 cost, uint256 supply, string ipfs_ufi);
    event CreateNftItem(address sender, Struct str);

    event EventPurchasedToken(address purchaser, uint tokenId, uint catId, uint catTokenid, uint amount);


    function initialize() initializer public { 
        __Ownable_init_unchained();
        __AccessControl_init_unchained();
        __Context_init_unchained();
        
        __ERC1155Burnable_init_unchained();
        __ReentrancyGuard_init_unchained();
        __ERC1155_init_unchained("");

        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _setupRole(ADMIN_ROLE, _msgSender());       
    }


    function showItemInCategory(uint256 category, uint256 id) public view  returns (Struct memory) {
       return structs[category][id];
    }

    /*
    * show categoryCount
    */
    function showCategoryCount(uint256 _catId) public view returns (CategoryStruct memory)  {
         return categoryStructs[_catId];
    }

    /*
    * create category that will be used for storing nft items together
    */
    function createCategory(string memory _name, string memory _desc) public onlyRole(ADMIN_ROLE) returns (CategoryStruct memory) 
        
    {
        uint256 catId = ++categoryId;
        categoryStructs[catId].categoryId = catId;
        categoryStructs[catId].name = _name;
        
        categoryStructs[catId].desc = _desc;
        categoryStructs[catId].createdAt = block.timestamp;
        
        return categoryStructs[catId];
    }

    /*
    * create nft item
    */
    function nftCreateItem(uint _category, address _author ,string memory _name, string memory _desc, bool isPurchasable, bool isAirdrop) 
        public onlyRole(ADMIN_ROLE) returns (Struct memory) 
    {
        // has to be greater than 0, so increment before setting the id
        uint tokId = ++tokenId;
        uint catIdTokId = ++totalStructs[_category];
        structs[_category][catIdTokId].airdrop = isAirdrop;   
        structs[_category][catIdTokId].purchasable = isPurchasable;   
        structs[_category][catIdTokId].catId = _category;
        structs[_category][catIdTokId].paused = true;
        structs[_category][catIdTokId].createdAt = block.timestamp;
        structs[_category][catIdTokId].catIdTokId = catIdTokId;
        structs[_category][catIdTokId].tokenId = tokId;
        structs[_category][catIdTokId].author = _author;
        structs[_category][catIdTokId].name = _name;
        structs[_category][catIdTokId].desc = _desc;

        
        
        address sender = _msgSender();
        emit CreateNftItem(sender, structs[_category][catIdTokId]);
        
        return structs[_category][tokId];
    }

    /*
    * turn on the nft sale by specifying cost, supply, start/end and ipfs url
    */
    function nftInitSale(uint _category, uint catIdTokId, uint _cost, uint _supply, uint _decimal, uint startAt, uint endAt, string memory ipfsUri ) 
        public onlyRole(ADMIN_ROLE) returns (Struct memory) 
    {
        uint id = structs[_category][catIdTokId].tokenId;
        require(id > 0 && id <= tokenId, "Invalid token id sent!");
        structs[_category][catIdTokId].paused = false;

        
        structs[_category][catIdTokId].startsAt = startAt;
        structs[_category][catIdTokId].endsAt = endAt;
        structs[_category][catIdTokId].supply = _supply;
        structs[_category][catIdTokId].supply = _supply;
        structs[_category][catIdTokId].cost = _cost * (10**18);
        structs[_category][catIdTokId].decimals = _decimal;
        structs[_category][catIdTokId].ipfs = ipfsUri;

        structs[0][structs[_category][catIdTokId].tokenId].ipfs = ipfsUri;

        address sender = _msgSender();
        emit CreateNftItem(sender, structs[_category][catIdTokId]);

        return structs[_category][catIdTokId];
    }

    /*
    * nft change start/stop date
    */
    function nftChangeDefaultSetting(uint _category, uint catIdTokId, uint256 cost,  uint256 supply,  string memory _ipfs, uint startAt, uint endAt,bool isPurchasbale, bool isAirdrop) public onlyRole(ADMIN_ROLE)  {
        //require(id > 0 && id < tokenId, "");
        uint id = structs[_category][catIdTokId].tokenId;
        require(id > 0 && id <= tokenId, "Invalid token id sent!");
        structs[_category][catIdTokId].ipfs = _ipfs;
        structs[0][id].ipfs = structs[_category][catIdTokId].ipfs;

        structs[_category][catIdTokId].startsAt = startAt;
        structs[_category][catIdTokId].endsAt = endAt;
        structs[_category][catIdTokId].cost = cost * (10**18);
        structs[_category][catIdTokId].supply = supply;
        structs[_category][catIdTokId].purchasable = isPurchasbale;
        structs[_category][catIdTokId].airdrop = isAirdrop;

        address sender = _msgSender();
        emit CreateNftItem(sender, structs[_category][catIdTokId]);
    }
      

    /*
    * Show items sold
    */
    function nftGetPrice(uint _category, uint catIdTokId) public view returns (uint)   {
        uint id = structs[_category][catIdTokId].tokenId;
        require(id > 0 && id <= tokenId, "Invalid token id sent!");


        return structs[_category][catIdTokId].cost;
    }


    function getTokenId(uint _category, uint catIdTokId) public view returns (uint)   {
        uint id = structs[_category][catIdTokId].tokenId;
        require(id > 0 && id <= tokenId, "Invalid token id sent!");
        return id;
    }

    /*
    * Show items sold
    */
    function nftItemsSold(uint _category, uint catIdTokId) public view returns (uint)   {
        uint id = structs[_category][catIdTokId].tokenId;
        require(id > 0 && id <= tokenId, "Invalid token id sent!");

        
        uint _totalSupply = totalSupply(id);
        return _totalSupply;
    }
    

    /*
    * pause nft
    */
    function nftPause(uint _category, uint catIdTokId, bool setPaused ) 
        public onlyRole(ADMIN_ROLE) returns (Struct memory) 
    {
        uint id = structs[_category][catIdTokId].tokenId;
        require(id > 0 && id <= tokenId, "Invalid token id sent!");

        structs[_category][catIdTokId].paused = setPaused;
        return structs[_category][catIdTokId];
    }

    // support interface for allowing role access control to work
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC1155Upgradeable, AccessControlUpgradeable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    /*
    *  Function adding wallet address as an admin
    */
    function addAddressAdmin(address newAddress) public onlyOwner {
        _grantRole(DEFAULT_ADMIN_ROLE, newAddress);
    }

    /*
    *  Function removing item from admin role
    */
    function removeAdmin(address removeAddress) public onlyOwner {
        _grantRole(DEFAULT_ADMIN_ROLE, removeAddress);
    }

    /*
    *  Function change the wallet address for where to store the sold tokens
    */
    function changeWalletStore(address newAddress) public onlyOwner {
        LPAD_WALLET_STORE_ADDRESS = newAddress;
    }

    /*
    * Show wallet address
    */
    function showWalletStoreAddress() public view  returns (address) {
       return LPAD_WALLET_STORE_ADDRESS;
    }

  
    // ** PAYOUT DISTRIBUTION: **
    function distribute(uint value) private {
        //balances[LPAD_WALLET_STORE_ADDRESS] += value;
        balances += value;
    }

    // ** WITHDRAW **
    // This function can be called by ANYONE who is willing to spend gas to withdraw the accumulated funds the PRE-DEFINED funding wallets.
    // (So funding will always go to the pre-set wallet stores, but the pay out can be requested by anyone.)
    function distributeFunds() public nonReentrant onlyRole(ADMIN_ROLE) {
        uint difference = balances - dispersed;
        require(difference != 0, "");
        payable(LPAD_WALLET_STORE_ADDRESS).transfer(difference);
        dispersed += difference;
    }
    
    /*
    * mint causes purchase to go through.   have to send catid, id + cost
    */
    function mint(uint256 catId, uint256 catIdTokId, uint256 amount)
        public
        payable
    {
       uint id = structs[catId][catIdTokId].tokenId;
        
        require(block.timestamp >= structs[catId][catIdTokId].startsAt , "This token hasnt started yet.");
        require(block.timestamp <= structs[catId][catIdTokId].endsAt, "This token has ended already!.");
        require(id > 0 && id <= tokenId, "Invalid token id sent!");
        require(!structs[catId][catIdTokId].paused, "This token is currently paused!");
        require(!structs[catId][catIdTokId].airdrop, "This token isn't set as airdrop!");
        require(!structs[catId][catIdTokId].soldOut, "This token is completely sold out!");
        
        address sender = _msgSender();
        uint _totalSupply = totalSupply(id);

        require(msg.value >= (structs[catId][catIdTokId].cost * amount),  "The need more money to purchase this!");
        require(_totalSupply <= structs[catId][catIdTokId].supply + amount,  "The  total supply you are wanting to purchase needs to be less than total supply!");
        
        
        _mint(sender, id, amount, "");
        emit MintEmit(sender, id, amount);
        
        _totalSupply = totalSupply(id);
             // incremeent
        structs[catId][catIdTokId].itemsSold = _totalSupply;
        
        // check to see if we ended total supply for this, if so, we need to set it as finished
        if(_totalSupply >= structs[catId][id].supply) {
            structs[catId][catIdTokId].soldOut = true;
        }



        // uint txid = ++txAuditCnt;
        // txAuditDetails[txid].txType = TxType.MINT;
        // txAuditDetails[txid].from = sender;
        // txAuditDetails[txid].amount = amount;
        // // txAudit[txid].to = ;
        // txAuditDetails[txid].tokenId = id;
        
        emit EventPurchasedToken(sender, id, catId, catIdTokId, amount);
        distribute(msg.value);
    }

    /*
    * airdrop causes purchase to go through.   have to send catid, id + cost
    */
    function mintAirdrop(uint256 catId, uint256 catIdTokId, uint256 amount, address airdropAddress) onlyRole(ADMIN_ROLE)
        public
        payable
    {
        uint id = structs[catId][catIdTokId].tokenId;
        
        require(id > 0 && id <= tokenId, "Invalid token id sent!");
        require(structs[catId][catIdTokId].airdrop, "This token isn't set as airdrop!");
        require(!structs[catId][catIdTokId].soldOut, "This token is sold out!");

        address sender =airdropAddress;// _msgSender();
        uint _totalSupply = totalSupply(id);
        
        require(_totalSupply <= structs[catId][catIdTokId].supply + amount,  "The  total supply you are wanting to purchase needs to be less than total supply!");
        
        
                
        _mint(sender, id, amount, "");
        emit MintEmit(sender, id, amount);
        
        _totalSupply = totalSupply(id);
             // incremeent
        structs[catId][catIdTokId].itemsSold = _totalSupply;
        
        // check to see if we ended total supply for this, if so, we need to set it as finished
        if(_totalSupply >= structs[catId][id].supply) {
            structs[catId][catIdTokId].soldOut = true;
        }
     
        emit EventPurchasedToken(sender, id, catId, catIdTokId, amount);
        distribute(msg.value);
    }
       
    function mintEmergencyAirdrop(uint256 catId, uint256 catIdTokId, uint256 amount, address airdropAddress) onlyRole(ADMIN_ROLE)
        public
        payable
    {
        uint id = structs[catId][catIdTokId].tokenId;
        
        require(id > 0 && id <= tokenId, "Invalid token id sent!");
        require(!structs[catId][catIdTokId].soldOut, "This token is sold out!");

        address sender =airdropAddress;// _msgSender();
        uint _totalSupply = totalSupply(id);


        require(_totalSupply <= structs[catId][catIdTokId].supply + amount,  "The  total supply you are wanting to purchase needs to be less than total supply!");
        
        
                
        _mint(sender, id, amount, "");
        emit MintEmit(sender, id, amount);
        
        _totalSupply = totalSupply(id);
             // incremeent
        structs[catId][catIdTokId].itemsSold = _totalSupply;
        
        // check to see if we ended total supply for this, if so, we need to set it as finished
        if(_totalSupply >= structs[catId][id].supply) {
            structs[catId][catIdTokId].soldOut = true;
        }
     
        emit EventPurchasedToken(sender, id, catId, catIdTokId, amount);
        distribute(msg.value);
    }


    // function mintBurn(uint256 catId, uint256 catIdTokId, uint256 amount) onlyRole(ADMIN_ROLE)
    //     public
    //     payable
    // {
    //     uint id = structs[catId][catIdTokId].tokenId;
        
    //     require(id > 0 && id <= tokenId, "Invalid token id sent!");
        

        
    //     address sender =0x0000000000000000000000000000000000000000;
    //     uint _totalSupply = totalSupply(id);

    //     require(_totalSupply <= structs[catId][catIdTokId].supply + amount,  "The  total supply you are wanting to purchase needs to be less than total supply!");
        
    //     _burn(sender, id, amount);
    //     emit MintBurnEmit(sender, id, amount);
        
    //     _totalSupply = totalSupply(id);
    //          // incremeent
    //     structs[catId][catIdTokId].itemsSold = _totalSupply;
        
    //     // check to see if we ended total supply for this, if so, we need to set it as finished
    //     if(_totalSupply >= structs[catId][id].supply) {
    //         structs[catId][catIdTokId].soldOut = true;
    //     }
     
    //     emit EventPurchasedToken(sender, id, catId, catIdTokId, amount);
       
    // }
    /*
    * retrieve ipfs link
    */
    function uri(uint256 _tokenId) public view virtual override returns (string memory) {
        require(_tokenId > 0 && _tokenId <= tokenId, "Send a valid id!");

        return string(abi.encodePacked(
            structs[0][_tokenId].ipfs 
        ));
    }

    function uriCatIdTokId(uint256 catId, uint256 catIdTokId) public view virtual  returns (string memory) {
        uint id = structs[catId][catIdTokId].tokenId;
        require(id > 0 && id <= tokenId, "Invalid token id sent!");


        return string(abi.encodePacked(
            structs[catId][catIdTokId].ipfs 
        ));
    }


    receive() external payable {
        require(msg.value > 0, "");
        distribute(msg.value);
    }

    // shows distribute stored 
    function soldGetReport() public onlyRole(ADMIN_ROLE) view returns (uint totalSold, uint totalDispersed, uint totalWaitingToDisperse) {
        uint difference = balances - dispersed;
        return (balances, dispersed, difference);
    }

    /**
    * @dev See {IERC1155-safeTransferFrom}.
    */
    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public virtual override {
        require(
            from == _msgSender() || isApprovedForAll(from, _msgSender()),
            "ERC1155: caller is not token owner nor approved"
        );
        _safeTransferFrom(from, to, id, amount, data);
        uint txid = ++txAuditCnt;
        txAuditDetails[txid].txType = TxType.TRANSFER;
        txAuditDetails[txid].from = from;
        txAuditDetails[txid].amount = amount;
        txAuditDetails[txid].to = to;
        txAuditDetails[txid].tokenId = id;
        
    }
    
    

    function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        internal
        whenNotPaused
        override(ERC1155Upgradeable, ERC1155SupplyUpgradeable, ERC1155PausableUpgradeable)
    {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }
}
