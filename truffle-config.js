const path = require("path");
require('babel-register');
require('babel-polyfill');
const HDWalletProvider = require('@truffle/hdwallet-provider');

const fs = require('fs');
const { mnemonic, BSCSCANAPIKEY, infuraKey} = require('./.env.json');



module.exports = {
   //etherscan API key
   api_keys: {
    etherscan: BSCSCANAPIKEY,
  },
  // plugin for verification
  plugins: ['truffle-plugin-verify','truffle-plugin-stdjsonin'],
  contracts_directory: './src/contracts/',
  //contracts_directory: './src/flattener/',

  contracts_build_directory: './src/abis/',
  compilers: {
    solc: {
      version: "^0.8.19",
      settings: {
        optimizer: {
          enabled: true,
          runs: 5000,
        },
        evmVersion: 'paris',
      }      
      
    },
  },
  
  networks: {
    
    brc: {
      provider: () => new HDWalletProvider(mnemonic,  "https://chainrpc.com/"),
      network_id: 32520,
      // confirmations: 10,
      // timeoutBlocks: 200,
      // skipDryRun: true
      skipDryRun: true,
      disableConfirmationListener: true,
      pollingInterval: 1800000,

      
        verify: {
          apiUrl: 'https://brisescan.com/api/eth-rpc',
          // apiKey: 'MY_API_KEY',
          // explorerUrl: 'https://brisescan.com/',
        }
      

    },
  
    develop: {
      port: 8545,
      host: "127.0.0.1",
      
      network_id: '*', // Match any network id
      gas: 4500000,
      gasPrice: 10000000000,  
    },

  },
};

