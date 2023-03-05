
const UniswapV2ERC20 = artifacts.require("UniswapV2ERC20");
const UniswapV2Factory = artifacts.require("UniswapV2Factory");
const UniswapV2Pair = artifacts.require("UniswapV2Pair");
const UniswapV2Router = artifacts.require("UniswapV2Router");
const { default: Web3 } = require('web3');

// See next migration for continuation ->
module.exports = function(deployer, _, accounts) {
  const [ tokenDeployer,  validator, fee, user1, user2, user3, ...rest ] = accounts;
  deployer.then(async function() {
    try {

      // Get user's Ethereum public address
      const ethereumAddress = (await web3.eth.getAccounts())[0];
      console.log("Ethereum 0:" + ethereumAddress);

      const accounts = await web3.eth.getAccounts();
      console.log("Account 0:" + accounts[0]);
      const test1 = await web3.eth.Contract.defaultAccount;
      console.log("Default account:" + test1);
      await web3.eth.getAccounts(console.log);

      await deployer.deploy(UniswapV2ERC20);
      const UniswapV2ERC20Instance = await UniswapV2ERC20.deployed();      
      console.log("UniswapV2ERC20 contract id: " + UniswapV2ERC20Instance.address);

      await deployer.deploy(UniswapV2Pair);
      const UniswapV2PairInstance = await UniswapV2Pair.deployed();      
      console.log("UniswapV2Pair contract id: " + UniswapV2PairInstance.address);


      //    constructor(address _feeToSetter) {
      await deployer.deploy(UniswapV2Factory, fee);
      const UniswapV2FactoryInstance = await UniswapV2Factory.deployed();      
      console.log("UniswapV2Factory contract id: " + UniswapV2FactoryInstance.address);
      
      // constructor(address _factory, address _WETH) {
      await deployer.deploy(UniswapV2Router, UniswapV2FactoryInstance.address, ethereumAddress);
      const UniswapV2RouterInstance = await UniswapV2Router.deployed();      
      console.log("UniswapV2Router contract id: " + UniswapV2RouterInstance.address);

      // will come back on this one
      // await deployer.deploy(Presale, UniswapV2ERC20Instance.address, tokenDeployer , false, false, { from: tokenDeployer });
      // const crowdsaleInstance = await Presale.deployed();
      // let  totalTokens =  await ERC20TokenInstance.totalSupply();
      // await ERC20TokenInstance.approve(crowdsaleInstance.address, totalTokens);

      // let ticketsPerThousandPercentage = await ERC20TokenInstance.ticketsPerThousandPercentage();
      // let tokenSellPercentage = 20;
      // let hardCap = (10 * tokenSellPercentage) * ticketsPerThousandPercentage;
      // let remainingToken = (100  - tokenSellPercentage) *  (ticketsPerThousandPercentage * 10)

      // console.log("presale totalSupply: " + totalTokens);
      // console.log("presale ticketsPerThousandPercentage: " + ticketsPerThousandPercentage);
      // console.log("presale hardcap: " + hardCap);
      // console.log("presale remainingItems: " + remainingToken);

      

    } catch (error) {
      console.log(error);
    }
  })
};

