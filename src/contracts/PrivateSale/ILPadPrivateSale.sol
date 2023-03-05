
interface ILPadPrivateSale {
    struct ConstructorParameters1 {
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
    }
    struct ConstructorParameters2 {
        uint256 StartTime;
        uint256 EndTime;
        uint256 SoftCap;
        uint256 HardCap;
        uint256 MinimumInvestment;
        uint256 MaximumInvestment;
        uint256 TGEPercentage;
        uint256 VestingCycle;
        uint256 VestingCyclePer;
        address FactoryContract;
        address TokenContractAddress;
        address OwnerAddress;
        bool WhiteListEnable;
    }
}
