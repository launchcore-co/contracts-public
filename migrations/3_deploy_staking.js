// const Token = artifacts.require('LPadTokenERC20');
// const LPadAirDropFactory = artifacts.require('LPadAirDropFactory');
// const LaunchPadAirDrop = artifacts.require('LaunchPadAirDrop');
// const LPadICOFactory = artifacts.require('LPadICOFactory');
// const LPadICOSale = artifacts.require('LPadICOSale');

const LPadMultiPoolStaking = artifacts.require("LPadMultiPoolStaking");
const LPadTestToken = artifacts.require("LPadTestToken");
// const LPadPresaleLiquidity = artifacts.require("LPadPresaleLiquidity");
// const UniswapV2Router = artifacts.require("UniswapV2Router");
// const UniswapV2Factory = artifacts.require("UniswapV2Factory");
const { default: Web3 } = require('web3');
// For tests purposes, it firstly deploys ERC20 token with parameters given in .env 
// and setting {tokenDeployer} account as owner, then mints amount defined in .env
// See next migration for continuation ->
module.exports = function(deployer, _, accounts) {
  const [ tokenDeployer, recepient, validator, ...rest ] = accounts;
  deployer.then(async function() {
    try {

        await deployer.deploy(LPadMultiPoolStaking);
        const lPadMultiPoolStaking = await LPadMultiPoolStaking.deployed();      
        console.log("LPadMultiPoolStaking contract id: " + lPadMultiPoolStaking.address);
  
        await deployer.deploy(LPadTestToken);
        const lPadTestToken = await LPadTestToken.deployed();      
        console.log("LPadTestToken contract id: " + lPadTestToken.address);
  
      
    //   const UniswapV2RouterInstance = await UniswapV2Router.deployed();      
    //   const UniswapV2FactoryInstance = await UniswapV2Factory.deployed();      
      

    } catch (error) {
      console.log(error);
    }
  })
};
