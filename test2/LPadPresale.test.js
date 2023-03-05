require("dotenv").config({ path: "../.env" }); 
const { chai, BN, testHelpers, presaleMigrationVars, tokenMigrationVars } = require("./setup.js");
const { tokenName, tokenSymbol, tokenTotalSupply } = tokenMigrationVars;
const { tokenSellPercentage, presaleAllowance, presaleDefaultRate } = presaleMigrationVars;
const { expectRevert } = testHelpers;
const { expect } = chai;

const ERC20Token = artifacts.require("LPadTokenERC20");
const LPadPresale = artifacts.require("LPadPresale");
const ethers = require('ethers');

//const Token = artifacts.require('LPadTokenERC20');

contract("LPadPresale", async function(accounts) {

    //const [ tokenDeployer, recepient, ...rest ] = accounts;
    const [ tokenDeployer,  validator, fee, user1, user2, user3, ...rest ] = accounts;
    let tokenInstance;
    let zero_address = "0x0000000000000000000000000000000000000000"; 

    async function getTokenInstance() {
      tokenInstance = await ERC20Token.deployed();
        return tokenInstance;
     }
    
     async function getPresaleInstance() {
      presaleInstance = await LPadPresale.deployed();
        return presaleInstance;
     }
    

    before("prepare pre-deployed instance", async function() {
        
        testToken =await getTokenInstance();
        testPresale = await getPresaleInstance();
    })


    describe('Checking token details', async () => {
        it('  token exists', async () => {
          assert.notEqual(testToken.address,zero_address);
        });
        it('  presale exists', async () => {
          assert.notEqual(testPresale.address,zero_address);
        });
        it('  Presale not initialized', async () => {
          let isInit = await testPresale.isInit();
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

        await testPresale.initSale(
          timestampNow + 35, // starttime
          timestampNow + 450, //endtime
          50, // liquidity portion
          BigInt(70000000000 * (10**18)), // salerate
           BigInt(50000000000*(10**18)), // end rate
          hardCap, //BigInt(3000000000000000), // hardcap
          softCap, //BigInt(2000000000000000), //softcap
          maxPurchase, //BigInt(3000000000000000), // maxbuy 
          minPurchase
          //{ from: tokenDeployer }
        ); //BigInt(3000000000000)); // minbuy
        
        let isInit = await testPresale.isInit();
        assert.equal(isInit, true);
      });
    });

      
    describe('Checking presale deposit is  false', async () => {
      it('  tokens been deposited?', async () => {
        let  isDeposit = await testPresale.isDeposit();
        assert.equal(isDeposit, false);
      });
      it('  ensure presale current offer 0 tokens', async () => {
        let  tokensBeingSold = await testPresale.presaleTokens( );
        assert.equal(tokensBeingSold, 0);
      });
      it('  deposit tokens and ensure tokens now offered', async () => {
        await testPresale.deposit();
        let  isDeposit = await testPresale.isDeposit();
        assert.equal(isDeposit, true);
      });
      
      // it('  tokens getTokeDepositDinfo', async () => {
      //   let  tokensBeingSold = await testPresale.presaleTokens( { from: tokenDeployer });
      //   //let  getTokeDepositDinfo = await testPresale.GetTokensForSale( { from: tokenDeployer }); //await testPresale.presaleTokens();
        
      //   assert.notEqual(tokensBeingSold, "0");
      // });


      it('  tokens being offered', async () => {
        //let  tokensBeingSold = await testPresale.getTokeDepositDinfo(); //await testPresale.presaleTokens();
        //expect(await testPresale.getTokeDepositDinfo()).to.be.a.bignumber.notEqual(0);

        //actual.should.be.a.bignumber.that.equals(0);
        let  tokensBeingSold = await testPresale.presaleTokens( );
        // let  tokensBeingSold2 = await testPresale.GetTokensForSale( { from: testPresale });
        // let tokenBeingSold3 = await testPresale.GetTokensForSale({ from: testToken})
        assert.notEqual(tokensBeingSold, "0");
      });
    });


});