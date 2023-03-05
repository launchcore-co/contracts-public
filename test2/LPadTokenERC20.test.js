require("dotenv").config({ path: "../.env" }); 
const { assert } = require("chai");
const { chai, BN, tokenMigrationVars, testHelpers } = require("./setup.js");
const { tokenName, tokenSymbol, tokenTotalSupply } = tokenMigrationVars;
const { expectRevert } = testHelpers;
const { expect } = chai;

const ERC20Token = artifacts.require("LPadTokenERC20");
//const Token = artifacts.require('LPadTokenERC20');

contract("LPadTokenERC20", async function(accounts) {

    const [ tokenDeployer, recepient, ...rest ] = accounts;
    let tokenInstance;
    let zero_address = "0x0000000000000000000000000000000000000000"; 

    async function getFreshInstance() {
      return ERC20Token.new(tokenName, tokenSymbol, tokenTotalSupply, { from: tokenDeployer});
      // ERC20Token.deployed();
      //    return tokenInstance;
     }
    
    before("prepare pre-deployed instance", async function() {
      // tokenInstance = await ERC20Token.deployed();
      const testToken =await getFreshInstance();
    })


    describe('Checking token details', async () => {
        
        it('  name', async () => {
          const name = await testToken.name();
          assert.equal(name, tokenName);
        });
        it('  symbol', async () => {
          var sym = await testToken.symbol();
          console.log("symbol: " + sym);
          assert.equal(sym, tokenSymbol);
        });
        it('  supply', async () => {
          const suppl = await testToken.totalSupply();
          console.log("suppl: " + suppl);
        });
        it('Tokens Per Thousandth Percentage: ', async () => {
          const calc = await testToken.ticketsPerThousandPercentage();
          console.log("calc: " + calc);
          assert.equal(calc * 1000, await testToken.totalSupply());
        });
        it('Token address: ', async () => {
          assert.notEqual(testToken.address, zero_address);
        });
      });

})