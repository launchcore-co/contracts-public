// const Token = artifacts.require('LPadTokenERC20');
// const LPadAirDropFactory = artifacts.require('LPadAirDropFactory');
// const LaunchPadAirDrop = artifacts.require('LaunchPadAirDrop');
// const LPadICOFactory = artifacts.require('LPadICOFactory');
// const LPadICOSale = artifacts.require('LPadICOSale');

const ERC20Token = artifacts.require("LPadTokenERC20");
const CreateToken = artifacts.require("CreateToken");
const Presale = artifacts.require("LPadPresale");
const LPadPresaleLiquidity = artifacts.require("LPadPresaleLiquidity");
const UniswapV2Router = artifacts.require("UniswapV2Router"); 
const UniswapV2Factory = artifacts.require("UniswapV2Factory"); 

const { default: Web3 } = require('web3');
// For tests purposes, it firstly deploys ERC20 token with parameters given in .env 
// and setting {tokenDeployer} account as owner, then mints amount defined in .env
// See next migration for continuation ->
module.exports = function(deployer, _, accounts) {
  const [ tokenDeployer, recepient, validator, ...rest ] = accounts;
  deployer.then(async function() {
    try {


      const ERC20TokenInstance = await ERC20Token.deployed();      
      const UniswapV2RouterInstance = await UniswapV2Router.deployed();      
      const UniswapV2FactoryInstance = await UniswapV2Factory.deployed();      
      
      console.log("CreateToken contract id: " + ERC20TokenInstance.address);

      //const presale = await presaleFactory.deploy(token.address, 18, 'Router', 'Factory', 'enter your marketing address here', 'enter the WBNB address here', true, false);

      // constructor(
      //   IERC20 _tokenInstance, 
      //   uint8 _tokenDecimals, 
      //   // address _uniswapv2Router, 
      //   // address _uniswapv2Factory,
      //   address _teamWallet,
      //   address _weth,
      //   bool _burnTokens,
      //   bool _isWhitelist
      //   ) {

       await deployer.deploy(Presale, ERC20TokenInstance.address, 18, tokenDeployer , false, false, { from: tokenDeployer });
       const crowdsaleInstance = await Presale.deployed();
       let  totalTokens =  await ERC20TokenInstance.totalSupply();
        await ERC20TokenInstance.approve(crowdsaleInstance.address, totalTokens);

       let ticketsPerThousandPercentage = await ERC20TokenInstance.ticketsPerThousandPercentage();
       let tokenSellPercentage = 20;
       let hardCap = (10 * tokenSellPercentage) * ticketsPerThousandPercentage;
       let remainingToken = (100  - tokenSellPercentage) *  (ticketsPerThousandPercentage * 10)

       console.log("presale totalSupply: " + totalTokens);
       console.log("presale ticketsPerThousandPercentage: " + ticketsPerThousandPercentage);
       console.log("presale hardcap: " + hardCap);
       console.log("presale remainingItems: " + remainingToken);


       const wethAddress = (await web3.eth.getAccounts())[0];
  

       var  token2 = await deployer.deploy(CreateToken, process.env.NAME, process.env.SYMBOL, process.env.TOTAL_SUPPLY);//, { from: tokenDeployer });
       const instance2 = await CreateToken.deployed();
       console.log("CreateToken contract id: " + token2.address  + ", Total supply: " + await token2.totalSupply() + ", thousand %: " + await token2.ticketsPerThousandPercentage());
    // constructor(
    //     IERC20 _tokenInstance, 
    //     uint8 _tokenDecimals, 
    //     address _uniswapv2Router, 
    //     address _uniswapv2Factory,
    //     address _teamWallet,
    //     address _weth,
    //     bool _burnTokens,
    //     bool _isWhitelist
    //     ) {
       await deployer.deploy(
          LPadPresaleLiquidity, 
          token2.address,  // token address
          18,
          UniswapV2RouterInstance.address, //router
          UniswapV2FactoryInstance.address, // factory          
          tokenDeployer,  // team wallet
          wethAddress, // weth address
          false, // burnTokens
          false);
       const LPadPresaleLiquidityInstance = await LPadPresaleLiquidity.deployed();
       console.log("LPadPresaleLiquidityInstance address: " + LPadPresaleLiquidityInstance.address);

    } catch (error) {
      console.log(error);
    }
  })
};
