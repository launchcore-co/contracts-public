
//import "github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.5/contracts/utils/cryptography/ECDSA.sol";
//import "github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.5/contracts/security/ReentrancyGuard.sol";
 import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
 import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

 pragma solidity >=0.4.16 <0.9.0;

contract SimpleStorage {
    uint storedData;

    function set(uint x) public { 
        storedData = x;
    }

    function get() public view returns (uint) {
        return storedData;
    }
}
