// const { assert, use } = require('chai');
// const { default: Web3 } = require('web3');

// const Token = artifacts.require('LPadTokenERC20');
// const Presale = artifacts.require('Presale');

// require('chai')
//   .use(require('chai-as-promised'))
//   .should();

// //helper function to convert tokens to ether
// function tokenCorvert(n) {
//   return web3.utils.toWei(n, 'ether');
// }

// //contract('LaunchStaking', ([creator, user]) => {
// contract('LaunchStaking', async function(accounts) {
//   const [ tokenDeployer, recepient, validator, ...rest ] = accounts;
//   let testToken, testPresale;
//   let tokenName = "TEST_TOKEN";
//   let tokenSym = "TST";
//   let totalSupply = 100;
//   before(async () => {
//     console.log("Initializing contract before tokens");
//     testToken = await Token.new(tokenName, tokenSym, totalSupply);
//     // constructor(
//     //   IERC20Metadata _tokenInstance, 
//     //   address _uniswapv2Router,  // commented out
//     //   address _uniswapv2Factory, // com,mented out
//     //   address _teamWallet,
//     //   address _weth, // commented out
//     //   bool _burnTokens,
//     //   bool _isWhitelist
//     //   ) {
//     var address = testToken.address();
//     log.console("Address: " + address);
//     // testPresale = await Presale.new(testToken.address(), deployerAccount, false, false);
//   });


//   describe('Checking token details', async () => {
//     it('  name', async () => {
//       const name = await testToken.name();
//       assert.equal(name, tokenName);
//     });
//     it('  symbol', async () => {
//       var sym = await testToken.symbol();
//       console.log("symbol: " + sym);
//       assert.equal(sym, tokenSym);
//     });
//     it('  supply', async () => {
//       const suppl = await testToken.totalSupply();
//       console.log("suppl: " + suppl);
//       var calc = suppl / (10**18);
//       console.log("calc: " + calc);
//       assert.equal(calc, totalSupply);
//     });
//   });

//   // it('Test supply', async () => {
//   //   var instance = await this.myToken;
//   //   var totalSupply = await instance.totalSupply();
//   //   var calc = totalSupply / (10**18);
    
//   //   console.log("Total supply " + calc);
//   //   assert.equal(totalSupply, 100 *(10** 18), 'default APY set to 100');
//   // });

// });

// //to run test - truffle test
