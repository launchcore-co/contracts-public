
// interface IBEP20 {
//     function balanceOf(address account) external view returns (uint256);
//     function transfer(address recipient, uint256 amount) external returns (bool);
//     function transferFrom( address sender, address recipient, uint256 amount ) external returns (bool);
//     function decimals() external view  returns (uint8);
//     function allowance(address owner,address spender) external view  returns (uint8);
//     function approve(address spender, uint256 amount) external returns (bool);
// }
interface IBEP20 {
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom( address sender, address recipient, uint256 amount ) external returns (bool);
    function decimals() external view  returns (uint8);
}

