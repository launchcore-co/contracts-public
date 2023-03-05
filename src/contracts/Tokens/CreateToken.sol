// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// // import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
// import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";
// import "@openzeppelin/contracts//utils/Context.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
// import "@openzeppelin/contracts/Token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
// import "./ERC20Burnable.sol";

contract CreateToken is ERC20, ERC20Burnable, Ownable {

    uint256 private _totalSupply;
    
    string private _name;
    string private _testSupply;
    string private _symbol;
    
    //   constructor(string memory TokenName, string memory Symbol, uint256 TotalSupply) 
    constructor(string memory TokenName,  string memory Symbol, uint256 TotalSupply) 
      ERC20(TokenName, Symbol)
      {
        _totalSupply = TotalSupply * (10 ** 18);

        _name = TokenName;
        _symbol = Symbol;
        _mint(owner(), _totalSupply);

        _testSupply = toString(_totalSupply / 1000 / (10**18));
        uint256 test = stringToUint(_testSupply) * 1000 ;

        require(TotalSupply == test);        
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    
    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT licence
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    function stringToUint(string memory s) public pure returns (uint) {
        bytes memory b = bytes(s);
        uint result = 0;
        for (uint256 i = 0; i < b.length; i++) {
            uint256 c = uint256(uint8(b[i]));
            if (c >= 48 && c <= 57) {
                result = result * 10 + (c - 48);
            }
        }
        return result;
    }

    function ticketsPerThousandPercentage() public view virtual  returns (uint256) {
        return _totalSupply / 1000;
    }
}
