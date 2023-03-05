"use strict";
require("dotenv").config({ path: "../.env" }); 
//CHAI
var chai = require("chai");
//BN
var BN = require("bn.js");
var chaiBN = require("chai-bn")(BN);
chai.use(chaiBN);
//TEST-HELPERS
var testHelpers = require("@openzeppelin/test-helpers");

/* VARIABLES SHARED WITH DEPLOYER USING .ENV */
const tokenMigrationVars = {
    tokenName: process.env.NAME,
    tokenSymbol: process.env.SYMBOL,
    tokenTotalSupply: new BN(process.env.TOTAL_SUPPLY),
    tokenMintedAmount: new BN(process.env.MINTED_AMOUNT),
    tokenDecimals: new BN(process.env.DECIMALS)
}
const presaleMigrationVars = {
    presaleAllowance: new BN(process.env.APPROVED_TO_SELL),
    presaleDefaultRate: new BN(process.env.DEFAULT_RATE),
    tokenSellPercentage: process.env.LIQUIDITY_PRESALE_PERCENTAGE
}

module.exports = {
    chai,
    BN,
    tokenMigrationVars,
    presaleMigrationVars,
    testHelpers
}