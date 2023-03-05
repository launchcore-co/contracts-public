// require("dotenv").config({ path: "../.env" }); 
// const { chai, BN, testHelpers, presaleMigrationVars, tokenMigrationVars } = require("./setup.js");
// const { tokenName, tokenSymbol, tokenTotalSupply } = tokenMigrationVars;
// const { tokenSellPercentage, presaleAllowance, presaleDefaultRate } = presaleMigrationVars;
// const { expectRevert } = testHelpers;
// const { expect } = chai;

// const ERC20Token = artifacts.require("LPadTokenERC20");
// const LPadPresale = artifacts.require("LPadPresale");
// const ethers = require('ethers');

// //const Token = artifacts.require('LPadTokenERC20');

// contract("LPadPresale", async function(accounts) {

//     //const [ tokenDeployer, recepient, ...rest ] = accounts;
//     const [ tokenDeployer,  validator, fee, user1, user2, user3, ...rest ] = accounts;

//     function sleep(ms) {
//       return new Promise((resolve) => {
//           setTimeout(resolve, ms);
//       });
//     }
//   it.skip("Pass args, deposit tokens, reach HC, finish sale, claim", async () =>  {

//     const tokenFactory = await ethers.getContractFactory("Token");
//     const token = await tokenFactory.deploy();
//     await token.deployed();
//     console.log("Token at: " + token.address);

//     const presaleFactory = await ethers.getContractFactory("Presale");
//     const presale = await presaleFactory.deploy(token.address, 18, '0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D', '0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f','0xced1cB80C96D4b98DbcBbD20af69A5396Ec3507C', '0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6', true, false);
//     await presale.deployed();
//     console.log('Presale at: '  + presale.address);

//     const approvePresale = await token.connect(creator).approve(presale.address, BigInt(1000000000000*(10**18)));
//     await approvePresale.wait();
    
//     const timestampNow = Math.floor(new Date().getTime()/1000);
//     const initSale = await presale.connect(creator).initSale(timestampNow + 35, timestampNow + 450, 75, BigInt(70000000000 * (10**18)), BigInt(50000000000*(10**18)), BigInt(3000000000000000), BigInt(2000000000000000), BigInt(3000000000000000), BigInt(3000000000000));
//     await initSale.wait();
//     console.log('Sale initialized');

//     const deposit = await presale.connect(creator).deposit();
//     await deposit.wait();
//     console.log('Tokens deposited.');
//     await sleep(50*1000);

//     const firstContribution = await user1.sendTransaction({
//         to: presale.address,
//         value: ethers.utils.parseEther('0.001')
//     })
//     await firstContribution.wait();
//     console.log('User 1 makes deposit');
  
//     const secondContribution = await user2.sendTransaction({
//         to: presale.address,
//         value: ethers.utils.parseEther('0.001')
//     })
//     await secondContribution.wait();
//     console.log('User 2 makes deposit');

//     const thirdContribution = await user3.sendTransaction({
//         to: presale.address,
//         value: ethers.utils.parseEther('0.001')
//     })
//     await thirdContribution.wait();
//     console.log('User 3 makes deposit');

//     const finishSale = await presale.connect(creator).finishSale();
//     await finishSale.wait();
//     console.log('Sale is concluded');

//     await sleep(10*1000);
//     const lockit = await presale.connect(creator).lockit();
//     await lockit.wait();
//     console.log("LP Locked");

//     const firstClaim = await presale.connect(user1).claimTokens();
//     await firstClaim.wait();
//     console.log("User 1 claims");

//     const secondClaim = await presale.connect(user2).claimTokens();
//     await secondClaim.wait();
//     console.log("User 2 claims");

//     const thirdClaim = await presale.connect(user3).claimTokens();
//     await thirdClaim.wait();
//     console.log("User 3 claims");


// });