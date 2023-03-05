
import "./../SolidityVersion.sol";
interface ILPadStaking {
    struct ConstructorParameters {
        string TokenName;
        string TokenSymbol;
        string StakingTitle;
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
        uint256 StartTime;
        address FactoryContract;
        address TokenContractAddress;
        address OwnerAddress;
    }
}

