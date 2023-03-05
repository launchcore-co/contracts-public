// scripts/deploy_upgradeable_box.js

const { ethers, upgrades } = require('hardhat');

async function main () {
  const CreateToken = await ethers.getContractFactory('CreateToken');
  console.log('Deploying CreateToken...');
  const createToken = await CreateToken.deploy( "test_token", "TST", 10000000, 18);
  console.log('createToken deployed to:', createToken.address);
  
  
  const LPadICOFactory = await ethers.getContractFactory('LPadICOFactory');
  console.log('Deploying LPadICOFactory...');
  const lpadICOFactory = await LPadICOFactory.deploy();
  console.log('lpadICOFactory deployed to:', lpadICOFactory.address);


  let _stringsList = [
    "TST",    //await getTokenName(data?.tokenAddress),
    "TST", // await getTokenSymbol(data?.tokenAddress),
    'https://www.pinksale.finance/static/media/ic-eth.9270fc02.svg',
     "https://google.com",
     "",
    "",
     "",
    ];

  let _numericsList = [
    "1000000000000000000", //data?.presaleRate),
    "100000000000000000", //data?.softCap),
    "200000000000000000", //data?.hardCap),
    "1666633674000000000000000000", //startDate),
    "1667238478000000000000000000", //endDate),
    "10000000000000000", //data?.minBuy),
    "100000000000000000", //data?.maxBuy),
  ];

  const LPadICOSale = await ethers.getContractFactory('LPadICOSale');
  console.log('Deploying LPadICOSale...');
  const lpadICOSale = await LPadICOSale.deploy(
      _stringsList,
      _numericsList,
      lpadICOFactory.address, //address _factotyContract,
      "0x39c13631B9E33380369aE7b8ec2cb5E6cdEa541B", //address _payoutContractAddress,
      createToken.address,  //address _idoTokenContractAddress,
      false //" // bool _isStakingRequired
  );
  console.log('lpadICOSale deployed to:', lpadICOSale.address);




}

main()
.then(() => process.exit(0))
.catch(error => {
console.error(error)
process.exit(1)
})  