// const { assert, use } = require('chai');
// const { default: Web3 } = require('web3');

// const Staking = artifacts.require('Staking');
// const FactoryContract = artifacts.require('FactoryContract');
// const TestToken = artifacts.require('TestToken');


// require('chai')
//   .use(require('chai-as-promised'))
//   .should();

// //helper function to convert tokens to ether
// function tokenCorvert(n) {
//   return web3.utils.toWei(n, 'ether');
// }

// contract('LaunchStaking', ([creator, user]) => {
//   let testToken, staking, stakingFc;

//   before(async () => {

//     //     struct ConstructorParameters {
//     //     string TokenName;
//     //     string TokenSymbol;
//     //     string StakingTitle;
//     //     string LogoURL;
//     //     string Website;
//     //     string Facebook;
//     //     string Twitter;
//     //     string Github;
//     //     string Telegram;
//     //     string Instagram;
//     //     string Discord;
//     //     string Reddit;
//     //     string Description;
//     //     uint256 StartTime;
//     //     address FactoryContract;
//     //     address TokenContractAddress;
//     //     address OwnerAddress;
//     // } 
//     testToken = await TestToken.new();
    
    
    
//       const structArray = [
//         "Static",
//         "STA",
//         "",
//         "",
//         "",
//         "",
//         "",
//         "",
//         "",
//         "",
//         "",
//         "",
//         "",
//         "100000000000",
//         "0x39c13631B9E33380369aE7b8ec2cb5E6cdEa541B",
//         testToken.address,
//         "0x39c13631B9E33380369aE7b8ec2cb5E6cdEa541B",
//       ];
      

//     //Load contracts
//     // console.trace(testToken.address);
//     // console.trace(structArray);
//     staking = await Staking.new(structArray);
//     // stakingFc = await FactoryContract.new(structArray, testToken.Address);

//     //transfer 500k to LaunchStaking
//     await testToken.transfer(tokenStaking.address, tokenCorvert('500000'));

//     //sending some test tokens to User at address[1] { explaining where it comes from}
//     await testToken.transfer(user, tokenCorvert('2234'), {
//       from: creator,
//     });
//   });

//   // Test 1
//   // 1.1 Checking if Token contract has a same name as expected
//   describe('TestToken deployment', async () => {
//     it('token deployed and has a name', async () => {
//       const name = await testToken.name();
//       assert.equal(name, 'TestToken');
//     });
//   });
// });


// //to run test - truffle test
