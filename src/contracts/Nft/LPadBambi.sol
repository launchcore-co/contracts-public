pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";


contract LPadBambiNFT is ERC1155, Ownable, Pausable, ERC1155Supply, AccessControl, ReentrancyGuard {
    // Create a new role identifier for the minter role
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");

    // You can change this to your own collection name
    string public constant name = "LPad Bambi Token";
    
    // You can change this to your own collection symbol
    string public constant symbol = "LPBT";

    // *** [🟢 CLASSES AND RARITY] ********************************************************************************************************************************
    // 🇬🇧🇺🇸: RARITY SECTION - Here you can specify what types of tokens are in your collection, what is their rarity (how many will be issued in each class) and the cost of a mint
    // 🇬🇧🇺🇸: how many "WOOD" copies can be minted (by default, these are free to mint)
    uint  public WOOD_MAX_SUPPLY = 10000; // 🥉
 
    // 🇬🇧🇺🇸: same as above, but each type is more rare and requires a higher donation
    uint  public BRONZE_MAX_SUPPLY = 1000; // 🥉
    uint  public SILVER_MAX_SUPPLY = 500; // 🥈
    uint  public GOLD_MAX_SUPPLY = 200; // 🥇
    uint  public DIAMOND_MAX_SUPPLY = 100; // 💎


    // 🇬🇧🇺🇸: let's set the purchase required for minting each class 
    uint  public WOOD_COST = 10 * (10**18); // 🔩 = 10  brise
    uint  public BRONZE_COST = 125000000 * (10**18); // 🔩 = 125 million brise
    uint  public SILVER_COST = 250000000 * (10**18); // 🥈 = 250 million brise
    uint  public GOLD_COST = 500000000 * (10**18); // 🥇 = 500 million brise
    uint  public DIAMOND_COST = 1000000000 * (10**18); // 💎 = 1B brise

    // Mapping from token ID to IPFS hash
    mapping (uint256 => string) private _tokenURIs;

    // *** [🛑 CLASSES AND RARITY] ********************************************************************************************************************************
    

    // *** [🟢 FUNDS DISTRIBUTION ] ********************************************************************************************************************************

    address private LPAD_WALLET_STORE_ADDRESS = 0xbDF7604279A31e4779BD0b895a2304aD0eF32157;

    // *** [🛑 FUNDS DISTRIBUTION ] ********************************************************************************************************************************
    mapping(address => uint) public balances;



    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    

    constructor() ERC1155("") {
        _grantRole(ADMIN_ROLE, owner());

        WOOD_COST = WOOD_COST;
        WOOD_MAX_SUPPLY = WOOD_MAX_SUPPLY;
        _tokenURIs[1] = "ipfs://CHANGE_THIS";
        // WOOD_IPFS_URI =  string(abi.encodePacked(IPFS_URI_LOCATION, WOOD_IPFS_URI_FILE));

        BRONZE_COST = BRONZE_COST;
        BRONZE_MAX_SUPPLY = BRONZE_MAX_SUPPLY;
        _tokenURIs[2] = "ipfs://CHANGE_THIS";
        // BRONZE_IPFS_URI = string(abi.encodePacked(IPFS_URI_LOCATION, BRONZE_IPFS_URI_FILE));

        SILVER_COST = SILVER_COST;
        SILVER_MAX_SUPPLY = SILVER_MAX_SUPPLY;
        _tokenURIs[3] = "ipfs://CHANGE_THIS";
        // SILVER_IPFS_URI =  string(abi.encodePacked(IPFS_URI_LOCATION, SILVER_IPFS_URI_FILE));

        GOLD_COST = GOLD_COST;
        GOLD_MAX_SUPPLY = GOLD_MAX_SUPPLY;
        _tokenURIs[4] = "ipfs://CHANGE_THIS";
        // GOLD_IPFS_URI =  string(abi.encodePacked(IPFS_URI_LOCATION, GOLD_IPFS_URI_FILE));
        
        DIAMOND_COST = DIAMOND_COST;
        DIAMOND_MAX_SUPPLY = DIAMOND_MAX_SUPPLY;
        _tokenURIs[5] = "ipfs://CHANGE_THIS";
        // DIAMOND_IPFS_URI =  string(abi.encodePacked(IPFS_URI_LOCATION, DIAMOND_IPFS_URI_FILE));
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC1155, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function addAddressAdmin(address newAddress) public onlyOwner {
        _grantRole(ADMIN_ROLE, newAddress);
    }

    function removeAdmin(address removeAddress) public onlyOwner {
        _grantRole(ADMIN_ROLE, removeAddress);
    }

    function changeWalletStore(address newAddress) public onlyOwner {
        LPAD_WALLET_STORE_ADDRESS = newAddress;
    }

    
    // 🇬🇧🇺🇸: replace IPFS link here "ipfs://Qmcw.." with your own metadata source
    function showWalletStoreAddress() public view  returns (address) {
       return LPAD_WALLET_STORE_ADDRESS;
    }

    function showTokenSold(uint256 id) public view returns (uint) {
        require(id > 0 && id < 6, "");
        uint _totalSupply = totalSupply(id);
       return _totalSupply;
    }
    
  
    // ** PAYOUT DISTRIBUTION: MULTIPLE BENEFICIARIES **
    function distribute(uint value) private {
        balances[LPAD_WALLET_STORE_ADDRESS] += value;
    }

    // ** WITHDRAW **
    // 🇬🇧🇺🇸: This function can be called by ANYONE who is willing to spend gas to withdraw the accumulated funds the PRE-DEFINED funding wallets.
    // 🇬🇧🇺🇸: (So funding will always go to the pre-set wallet stores, but the pay out can be requested by anyone.)
    function withdraw(address _to) public nonReentrant {
        require(balances[_to] != 0, "");
        payable(_to).transfer(balances[_to]);
        balances[_to] = 0;
    }


    function pause()  public onlyRole(ADMIN_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(ADMIN_ROLE) {
        _unpause();
    }

    function changeCost(uint256 id, uint256 cost) public onlyRole(ADMIN_ROLE)  {
        require(id > 0 && id < 6, "");
        if (id == 1) {
            require(cost > 0, "");
            WOOD_COST = cost;
        }
        if (id == 2) {
            require(cost > 0, "");
            BRONZE_COST = cost;
        }
        if (id == 3) {
            require(cost > 0, "");
            SILVER_COST = cost;
        }
        if (id == 4) {
            require(cost > 0, "");
            GOLD_COST = cost;
        }
        if (id == 5) {
            require(cost > 0, "");
            DIAMOND_COST = cost;
        }
    }

    function changeSupply(uint256 id, uint256 supply) public onlyRole(ADMIN_ROLE) {
        require(id > 0 && id < 6, "");
        if (id == 1) {
            require(supply > 0, "");
            WOOD_MAX_SUPPLY = supply;
        }
        if (id == 2) {
            require(supply > 0, "");
            BRONZE_MAX_SUPPLY = supply;
        }
        if (id == 3) {
            require(supply > 0, "");
            SILVER_MAX_SUPPLY = supply;
        }
        if (id == 4) {
            require(supply > 0, "");
            GOLD_MAX_SUPPLY = supply;
        }
        if (id == 5) {
            require(supply > 0, "");
            DIAMOND_MAX_SUPPLY = supply;
        }
    }    

    function mint(uint256 id, uint256 amount)
        public
        payable
    {
        require(id > 0 && id < 6, "");

        address sender = _msgSender();
        uint _totalSupply = totalSupply(id);

        if (id == 1) {
            require(_totalSupply < WOOD_MAX_SUPPLY && msg.value >= (WOOD_COST * amount), "");
            _mint(sender, id, amount, "");
        }

        if (id == 2) {
            require(_totalSupply < BRONZE_MAX_SUPPLY && msg.value >= (BRONZE_COST * amount), "");
            _mint(sender, id, amount, "");
        }

        if (id == 3) {
            require(_totalSupply < SILVER_MAX_SUPPLY && msg.value >= (SILVER_COST * amount), "");
            _mint(sender, id, amount, "");
        }

        if (id == 4) {
            require(_totalSupply < GOLD_MAX_SUPPLY && msg.value >= (GOLD_COST * amount), "");
            _mint(sender, id, amount, "");
        }

        if (id == 5) {
            require(_totalSupply < DIAMOND_MAX_SUPPLY && msg.value >= (DIAMOND_COST * amount), "");
            _mint(sender, id, amount, "");
        }

        distribute(msg.value);
    }

    function setTokenIpfs(uint256 id, string memory uriFile) public onlyRole(ADMIN_ROLE) 
    {
        require(id > 0 && id < 6, "Send a valid id!");
        bytes memory tempEmptyStringTest = bytes(uriFile); // Uses memory
        require(tempEmptyStringTest.length != 0, "uriFIle must not be empty");
        if (id == 1) {
            _tokenURIs[1] = uriFile;
        }

        if (id == 2) {
            _tokenURIs[2] = uriFile;
        }

        if (id == 3) {
            _tokenURIs[3] = uriFile;
        }

        if (id == 4) {
            _tokenURIs[4] = uriFile;
        }

        if (id == 5) {
            _tokenURIs[5] = uriFile;
        }
    }
 
    // 🇬🇧🇺🇸: replace IPFS link here "ipfs://Qmcw.." with your own metadata source
    function uri(uint256 tokenId) public view virtual override returns (string memory) {
        if (tokenId == 1) {
            return string(abi.encodePacked(
                _tokenURIs[1]
            ));
        }
        if (tokenId == 2) {
            return string(abi.encodePacked(
                _tokenURIs[2]
            ));
        }
        if (tokenId == 3) {
            return string(abi.encodePacked(
                _tokenURIs[3]
            ));
        }
        if (tokenId == 4) {
            return string(abi.encodePacked(
                _tokenURIs[4]
            ));
        }
        if (tokenId == 5) {
           return string(abi.encodePacked(
                _tokenURIs[5]
            ));
        }

        return string(abi.encodePacked(
            "ipfs://INVALID_ITEM/UNKNOWN_TOKEN_ID.json"
        ));        
    }

    receive() external payable {
        require(msg.value > 0, "");
        distribute(msg.value);
    }

    function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        internal
        whenNotPaused
        override(ERC1155, ERC1155Supply)
    {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }
}
