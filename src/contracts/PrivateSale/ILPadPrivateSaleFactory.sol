import "./ILPadPrivateSale.sol";

interface ILPadPrivateSaleFactory is ILPadPrivateSale {
    function CollectPrivateSaleData(ConstructorParameters1 memory _params1, 
                    ConstructorParameters2 memory _params2, 
                    address _PrivateSaleContractAddress) external;
}
