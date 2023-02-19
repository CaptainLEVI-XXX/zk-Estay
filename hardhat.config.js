require('@nomiclabs/hardhat-waffle');
require('dotenv').config();
const API_KEY=process.env.API_KEY;
const YOUR_PRIVATE_KEY=process.env.YOUR_PRIVATE_KEY;

module.exports = {
  solidity: "0.8.17",
  networks: {
    mumbai: {
      url:`https://polygon-mumbai.g.alchemy.com/v2/${API_KEY}`,
      accounts: [`${YOUR_PRIVATE_KEY}`]
    },
  }
};