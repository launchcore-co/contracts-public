// SPDX-License-Identifier: Unlicensed
  /* solhint-disable */
pragma solidity ^0.8.17;

//  import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
// import {
//     Ownable
// } from "@openzeppelin/contracts/access/Ownable.sol";

// A + G == VNL
// https://github.com/kirilradkov14


contract LPadTokenERC20 is ERC20Burnable, Ownable {
    using SafeMath for uint256;
        mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;
    
    

    string private _name;
    string private _testSupply;
    string private _symbol;


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

    constructor(string memory Name,  string memory Symbol, uint256 TotalSupply) 
      ERC20(Name, Symbol)
      {
        _totalSupply = TotalSupply * (10 ** 18);

        _name = Name;
        _symbol = Symbol;
        _mint(owner(), _totalSupply);

        _testSupply = toString(_totalSupply / 1000 / (10**18));
        uint256 test = stringToUint(_testSupply) * 1000 ;

        require(TotalSupply == test);        
    }

    function ticketsPerThousandPercentage() public view virtual  returns (uint256) {
        return _totalSupply / 1000;
    }


}