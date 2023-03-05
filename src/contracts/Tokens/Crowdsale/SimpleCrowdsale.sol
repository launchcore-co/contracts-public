pragma solidity ^0.8.17;

import "./Crowdsale.sol";

contract SimpleCrowdsale is Crowdsale {

    constructor(
        uint256 r,
        address payable w,
        IERC20 t
    ) Crowdsale(r,w,t) {
        
    }

  
}
