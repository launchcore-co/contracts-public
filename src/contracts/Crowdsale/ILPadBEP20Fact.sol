import "./ILPadICO.sol";



// Interface factory of IDOFactoryContract
interface ILPadBEP20Fact is ILPadICO {
    function CollectIDOData(string[] memory _stringsList,uint256[] memory _numericList,address _AddrOwnerMetamask,address _IntractionContractAddr) external;
    function setIDOPresaleRate(address __interationAddr, uint256 _price) external;
    function setIDOSoftHardCap(address __interationAddr,uint256 _softCap,uint256 _hardCap) external;
    function setIDOStartEndTime(address __interationAddr,uint256 _stime,uint256 _etime) external;
    function setIDOGlobalMinMaxBuy(address __interationAddr,uint256 _min,uint256 _max) external;
    function getSocialMedia(address _interationAddr) external view returns(string memory, string memory, string memory, string memory, string memory, string memory, string memory);
    function setSocialMedia(address _interationAddr, string memory _ico, string memory _fb, string memory _twitter, string memory _website, string memory _desc) external;
    function idoCounter() external view returns(uint8);
}
