// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface ILPadICO {
    struct ConstructorParameters {
        string TokenName;
        string TokenSymbol;
        string TokenIcon;
        string TokenFb;
        string TokenTwitter;
        string TokenWebsite;
        string TokenDescription;
        uint256 PresaleRate;
        uint256 SoftCap;
        uint256 HardCap;
        uint256 StartTime;
        uint256 EndTime;
        uint256 MinBuyRange;
        uint256 MaxBuyRange;
        address FactoryContract;
        address PayoutContractAddress;
        address IdoTokenContractAddress;
        address AddrOwnerMetamask;
        address IntractionContractAddr;
        bool WhiteListEnable;
        bool RefundTypeBurn;
        bool VestingEnable;
    }
}