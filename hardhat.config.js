require("@nomicfoundation/hardhat-toolbox");
require('@nomiclabs/hardhat-ethers');
require('@openzeppelin/hardhat-upgrades');
const HDWalletProvider = require('@truffle/hdwallet-provider');

const fs = require('fs');
const { mnemonic, BSCSCANAPIKEY, infuraKey} = require('./.env.json');


/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
    //etherscan API key
  api_keys: {
    etherscan: BSCSCANAPIKEY,
  },
  solidity: {
    version: "0.8.17",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
  networks: {
    // brc: {
    //   provider: () => new HDWalletProvider(mnemonic,  "https://chainrpc.com/"),
    //   network_id: 32520,
    //   // confirmations: 10,
    //   // timeoutBlocks: 200,
    //   // skipDryRun: true
    // },
    localhost: {
      chainId: 32520,

      url:"https://chainrpc.com",
      gas: 4500000,
      gasPrice: 10000000000,      
    },
    development: {
      url: '127.0.0.1',
      // host: '127.0.0.1',
      port: 8545,
      network_id: '*', // Match any network id
      gas: 4500000,
      gasPrice: 10000000000,  
    },
  },
  paths: {
    sources: "./src/contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts"
  },
  mocha: {
    timeout: 40000
  },
  namedAccounts: {
    account0: 0,
    account1: 1
  },

}

;
