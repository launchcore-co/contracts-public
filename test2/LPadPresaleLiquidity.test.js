require("dotenv").config({ path: "../.env" }); 
const { chai, BN, testHelpers, presaleMigrationVars, tokenMigrationVars } = require("./setup.js");
const { tokenName, tokenSymbol, tokenTotalSupply } = tokenMigrationVars;
const { tokenSellPercentage, presaleAllowance, presaleDefaultRate } = presaleMigrationVars;
const { expectRevert } = testHelpers;
const { expect } = chai;

const CreateToken = artifacts.require("CreateToken");
const LPadPresaleLiquidity = artifacts.require("LPadPresaleLiquidity");

const UniswapV2ERC20 = artifacts.require("UniswapV2ERC20");
const UniswapV2Factory = artifacts.require("UniswapV2Factory");
const UniswapV2Pair = artifacts.require("UniswapV2Pair");
const UniswapV2Router = artifacts.require("UniswapV2Router");
const ethers = require('ethers');
const { default: Web3 } = require('web3');
//const Token = artifacts.require('LPadTokenERC20');

contract("LPadPresaleLiquidity", async function(accounts) {
  
    //const [ tokenDeployer, recepient, ...rest ] = accounts;
    const [ tokenDeployer,  teamWallet, fee, user1, user2, user3, ...rest ] = accounts;
    
    let wethAddress, factoryInstance, routeInstance, testToken, testPresaleLiquid;
    let zero_address = "0x0000000000000000000000000000000000000000"; 
    const defaultMsgValue = web3.utils.toWei(new BN(1));
  
    async function getTokenInstance() {
      return CreateToken.new(tokenName, tokenSymbol, tokenTotalSupply, { from: tokenDeployer});
    }
    
    async function getFactoryInstance() {
        return UniswapV2Factory.new(fee);
    }

    async function  getRouternstance() {
        return UniswapV2Router.new(factoryInstance.address, wethAddress);
    }

    async function getPresaleInstance() {
       return LPadPresaleLiquidity.new( 
          testToken.address,  // token address
          routeInstance.address, //router
          factoryInstance.address, // factory
          teamWallet,  // team wallet
          wethAddress, // weth address
          false, // burnTokens
          false);
    }
    
    before("prepare pre-deployed instance", async function() {
       wethAddress = (await web3.eth.getAccounts())[0];
       testToken =await getTokenInstance();
       factoryInstance = await getFactoryInstance();
       routeInstance = await getRouternstance();
       testPresaleLiquid = await getPresaleInstance();
      
    });


    describe('Checking token details', async () => {
      it('  wethAddress exists', async () => {
        assert.notEqual(wethAddress.address,zero_address);
      });
      
      it('  factory exists', async () => {
        assert.notEqual(factoryInstance.address,zero_address);
      });
      it('  route exists', async () => {
        assert.notEqual(routeInstance.address,zero_address);
      });
        it('  token exists', async () => {
          assert.notEqual(testToken.address,zero_address);
        });
        it('  presale exists', async () => {
          assert.notEqual(testPresaleLiquid.address,zero_address);
        });
        it('  Presale not initialized', async () => {
          let isInit = await testPresaleLiquid.isInit();
          assert.equal(isInit, false);
        });
    });

    describe('initialize presale', async () => {

      it('  Presale not initialized', async () => {
        let hardCap = 20 * 10 * tokenSellPercentage;
        let  softCap = hardCap / 2;
        let maxPurchase = softCap / 2; 
        let minPurchase =   maxPurchase / 10;
        const timestampNow = Math.floor(new Date().getTime()/1000);

        await testPresaleLiquid.initSale(
          timestampNow + 35, // starttime
          timestampNow + 450, //endtime
          50, // liquidity portion
           BigInt(70000000000 * (10**18)), // salerate
           BigInt(50000000000*(10**18)), // listRate
          hardCap, //BigInt(3000000000000000), // hardcap
          softCap, //BigInt(2000000000000000), //softcap
          maxPurchase, //BigInt(3000000000000000), // maxbuy 
          minPurchase // minBuy
          //{ from: tokenDeployer }
        ); //BigInt(3000000000000)); // minbuy
        
        let isInit = await testPresaleLiquid.isInit();
        assert.equal(isInit, true);
      });
    });

      
    describe('Checking presale deposit is  false', async () => {
      it('  tokens been deposited?', async () => {
        let  isDeposit = await testPresaleLiquid.isDeposit();
        assert.equal(isDeposit, false);
      });
      
      it('  ensure presale current offer 0 tokens', async () => {
        let  tokensBeingSold = await testPresaleLiquid.presaleTokens( );
        assert.equal(tokensBeingSold, 0);
      });
      
      it('  deposit tokens and ensure tokens now offered', async () => {

        let  totalTokens =  await testToken.totalSupply();
        await testToken.approve(testPresaleLiquid.address, totalTokens,  { from: tokenDeployer });

        await testPresaleLiquid.deposit();
        let  isDeposit = await testPresaleLiquid.isDeposit();
        assert.equal(isDeposit, true);
     
        //actual.should.be.a.bignumber.that.equals(0);
        let  tokensBeingSold = await testPresaleLiquid.presaleTokens( );
        assert.notEqual(tokensBeingSold, "0");
        
        
        let balance = await testPresaleLiquid.balanceOf(testToken.address);
        assert.notEqual(balance, "0");

      });
    });

    describe('Add contributions', async () => {
      //await testPresaleLiquid.buyTokens({ from: rest[0], value: defaultMsgValue }); // buy tokens for 1Eth

      
      //   it("should buy tokens to unvalidated address", async function() {
      //     await expectRevert(
      //         crowdsaleInstance.buyTokens({ from: rest[0], value: defaultMsgValue }),
      //         "Crowdsale: Caller KYC is not completed yet."
      //     )
      // })

      // it("should reject validation if caller is not validator", async function() {
      //     await expectRevert(
      //         kycCheckInstace.setKYCComleted(rest[0], { from: rest[0] }),
      //         "Ownable: caller is not the owner"
      //     )
      // })


      // const firstContribution = await testPresaleLiquid.buy.sendTransaction({
      //   from: user1.address,
      //   value: ethers.utils.parseEther('0.001')
      // })
      // await firstContribution.wait();
      // console.log('User 1 makes deposit');
    
    });
  
});