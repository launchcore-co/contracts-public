// scripts/deploy_upgradeable_box.js

const { ethers, upgrades } = require('hardhat');

async function main () {
  const CreateToken = await ethers.getContractFactory('CreateToken');
  console.log('Deploying CreateToken...');
  const createToken = await CreateToken.deploy( "test_token", "TST", 10000000, 18);
  console.log('createToken deployed to:', createToken.address);
  
  
  const LPadStakingFactory = await ethers.getContractFactory('LPadStakingFactory');
  console.log('Deploying LPadStakingFactory...');
  const lpadStakingFactory = await LPadStakingFactory.deploy();
  console.log('LPadStakingFactory deployed to:', lpadStakingFactory.address);

  const stakingFcArray = [
    "Static",   // TokenName
    "STA",      // TokenSymbol
    "",         // StakingTitle
    "",         // LogoURL
    "",         // Website
    "",         // Facebook
    "",         // Twitter
    "",         // Github
    "",         // Telegram
    "",         // Instagra
    "",         // Discord
    "",         // Reddit
    "",          //   Description
    0,          // startTime
    lpadStakingFactory.address, // factoryContract
    createToken.address, // TokenContractAddress     
    "0x39c13631B9E33380369aE7b8ec2cb5E6cdEa541B", // owner
  ];
  const LPadStaking = await ethers.getContractFactory('LPadStaking');
  console.log('Deploying LPadStaking...');
  const lpadStaking = await LPadStaking.deploy(stakingFcArray);

  console.log('LPadStaking deployed to:', lpadStaking.address);




}

main()
.then(() => process.exit(0))
.catch(error => {
console.error(error)
process.exit(1)
})  