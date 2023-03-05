pragma solidity ^0.8.17;

import "./MintedCrowdsale.sol";

contract MintedCrowdsaleImpl is MintedCrowdsale {
    constructor (uint256 rate, address payable wallet, IERC20 token) public MintedCrowdsale(rate, wallet, token) {
        // solhint-disable-previous-line no-empty-blocks
    }

      

}
