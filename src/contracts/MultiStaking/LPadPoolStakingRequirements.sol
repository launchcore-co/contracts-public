pragma solidity ^0.8.17;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Address.sol";
abstract contract Auth {
	address public owner;
	mapping(address => bool) internal authorizations;

	constructor() {
		owner = msg.sender;
		authorizations[msg.sender] = true;
	}

	modifier onlyOwner() {
		require(isOwner(msg.sender), "!OWNER");
		_;
	}

	modifier authorized() {
		require(isAuthorized(msg.sender), "!AUTHORIZED");
		_;
	}

	function authorize(address adr) public authorized {
		authorizations[adr] = true;
	}

	function unauthorize(address adr) public authorized {
		authorizations[adr] = false;
	}

	function isOwner(address account) public view returns (bool) {
		return account == owner;
	}

	function isAuthorized(address adr) public view returns (bool) {
		return authorizations[adr];
	}

	function transferOwnership(address payable adr) public authorized {
		owner = adr;
		authorizations[adr] = true;
		emit OwnershipTransferred(adr);
	}

	function renounceOwnership() public authorized {
		address dead = 0x000000000000000000000000000000000000dEaD;
		owner = dead;
		emit OwnershipTransferred(dead);
	}

	event OwnershipTransferred(address owner);
}

interface IERC165 {
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

/**
 * @dev Required interface of an ERC721 compliant contract.
 */
interface IERC721 is IERC165 {
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    function balanceOf(address owner) external view returns (uint256 balance);

    function ownerOf(uint256 tokenId) external view returns (address owner);

    function safeTransferFrom(address from, address to, uint256 tokenId) external;

    function transferFrom(address from, address to, uint256 tokenId) external;

    function approve(address to, uint256 tokenId) external;

    function getApproved(uint256 tokenId) external view returns (address operator);

    function setApprovalForAll(address operator, bool _approved) external;

    function isApprovedForAll(address owner, address operator) external view returns (bool);

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
}

interface IERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address to, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}