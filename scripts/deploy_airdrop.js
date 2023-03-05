// scripts/deploy_upgradeable_box.js

const { ethers, upgrades } = require('hardhat');

async function main () {
  const CreateToken = await ethers.getContractFactory('CreateToken');
  console.log('Deploying CreateToken...');
  const createToken = await CreateToken.deploy( "test_token", "TST", 10000000, 18);
  console.log('createToken deployed to:', createToken.address);
  
  const LPadAirDropFactory = await ethers.getContractFactory('LPadAirDropFactory');
  
  const lpadAirDropFactory = await LPadAirDropFactory.deploy();
  console.log("LPadAirDropFactory contract id: " + lpadAirDropFactory.address);


//   string ;
//   string ;
//   string ;
//   string ;
//   string ;
//   string ;
//   string ;
//   string ;
//   uint256 ;
//   uint256 ;
//   uint256 ;
//   address ;
//   address ;
//   address ;
const stakingFcArray = [
      "Static",   // TokenName
      "STA",      // TokenSymbol
      "",         // AirdropTitle
      "",         // LogoURL
      "",         // Website
      "",         // Facebook
      "",         // Twitter
      "",         // Github
      "",         // Telegram
      "",         // Instagram
      "",         // Discord
      "",         // Reddit
      "",          //   Description
      0,          // StartTime
      0,                   // TotalAllocation_10
      0,              // TotalAllocation_10
      lpadAirDropFactory.address, // FactoryContract
      createToken.address,                                   // TokenContractAddress
      "0x39c13631B9E33380369aE7b8ec2cb5E6cdEa541B", // OwnerAddress
    ];


  const LaunchPadAirDrop = await ethers.getContractFactory('LaunchPadAirDrop'); 
  

  const launchPadAirDrop = await LaunchPadAirDrop.deploy( stakingFcArray );
   console.log("LaunchPadAirDrop contract id: " + launchPadAirDrop.address);

//   console.log("LaunchPadAirDrop contract id: " + launchPadAirDrop.address);

}

main()
.then(() => process.exit(0))
.catch(error => {
console.error(error)
process.exit(1)
})  