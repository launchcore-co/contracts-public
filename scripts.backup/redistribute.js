const LaunchStaking = artifacts.require('LaunchStaking');

module.exports = async function(callback) {
  if (process.argv[4] === 'custom') {
    let launchStaking = await LaunchStaking.deployed();
    await launchStaking.customRewards();
    console.log('--- Daily [custom] rewards have been redistributed ---');
    callback();
  } else if (!process.argv[4]) {
    let launchStaking = await LaunchStaking.deployed();
    await launchStaking.redistributeRewards();
    console.log('--- Daily rewards have been redistributed ---');
    callback();
  } else {
    console.log(
      'Error: Invalid argument provided, for custom reward redistribution use: truffle exec scripts/redistribute.js custom'
    );
  }
};

//to run script  -  truffle exec scripts/redistribute.js
//to run custom redistribution   -  truffle exec scripts/redistribute.js custom

