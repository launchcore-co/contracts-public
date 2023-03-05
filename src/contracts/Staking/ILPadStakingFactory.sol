import "./ILPadStaking.sol";

interface ILPadStakingFactory is ILPadStaking {
    function CollectStakingData(ConstructorParameters memory _params, address _StakingContractAddress)  external;
}
