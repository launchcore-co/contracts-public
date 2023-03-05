
require("dotenv").config({ path: "../.env" }); 
const Migrations = artifacts.require("Migrations");


module.exports = function(deployer) {
  if (!Boolean(process.env.NAME)) {
    console.error("Missing NAME  value!   This is required, and should be in the root repo in file .env");
    process.kill();
    
  }
  if (!Boolean(process.env.SYMBOL)) {
    console.error("Missing SYMBOL  value!   This is required, and should be in the root repo in file .env");
    process.kill();
  }
  if (!Boolean(process.env.TOTAL_SUPPLY )) {
    console.error("Missing TOTAL_SUPPLY  value!   This is required, and should be in the root repo in file .env");
    process.kill();
  }
  if (!Boolean(process.env.LIQUIDITY_PRESALE_PERCENTAGE  )) {
    console.error("Missing LIQUIDITY_PRESALE_PERCENTAGE  value!   This is required, and should be in the root repo in file .env");
    process.kill();
  }
  if (!Boolean(process.env.LIQUIDITY_SWAP  )) {
    console.error("Missing LIQUIDITY_SWAP  value!   This is required, and should be in the root repo in file .env");
    process.kill();
  }
  if (!Boolean(process.env.MINTED_AMOUNT  )) {
    console.error("Missing MINTED_AMOUNT  value!   This is required, and should be in the root repo in file .env");
    process.kill();
  }
   
  if (!Boolean(process.env.APPROVED_TO_SELL   )) {
    console.error("Missing APPROVED_TO_SELL   value!   This is required, and should be in the root repo in file .env");
    process.kill();
  }
   
  if (!Boolean(process.env.DEFAULT_RATE   )) {
    console.error("Missing DEFAULT_RATE   value!   This is required, and should be in the root repo in file .env");
    process.kill();
  }
   
  if (!Boolean(process.env.DECIMALS   )) {
    console.error("Missing DECIMALS   value!   This is required, and should be in the root repo in file .env");
    process.kill();
  }
   



    console.log(     "NAME: " + process.env.NAME);
  deployer.deploy(Migrations);
};
