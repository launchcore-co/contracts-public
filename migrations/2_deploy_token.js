const ERC20Token = artifacts.require("LPadTokenERC20");
const CreateToken = artifacts.require("CreateToken");
module.exports = function(deployer, _, accounts) {
  const [ tokenDeployer,  validator, fee, user1, user2, user3, ...rest ] = accounts;
  deployer.then(async function() {
    try {
      var  token = await deployer.deploy(ERC20Token, process.env.NAME, process.env.SYMBOL, process.env.TOTAL_SUPPLY, { from: tokenDeployer });
      const instance = await ERC20Token.deployed();
      console.log("CreateToken contract id: " + token.address  + ", Total supply: " + await token.totalSupply() + ", thousand %: " + await token.ticketsPerThousandPercentage());
      
      var  token2  = await deployer.deploy(CreateToken, process.env.NAME, process.env.SYMBOL, process.env.TOTAL_SUPPLY, { from: tokenDeployer });
      const instance2 = await ERC20Token.deployed();
      console.log("CreateToken contract id: " + token2.address  + ", Total supply: " + await token2.totalSupply() + ", thousand %: " + await token2.ticketsPerThousandPercentage());
      


      // await instance.mint(process.env.MINTED_AMOUNT, tokenDeployer, { from: tokenDeployer });
    } catch (error) {
      console.log(error);
    }
  })
};

