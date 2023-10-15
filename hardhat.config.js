require("@nomicfoundation/hardhat-toolbox");
require('@nomiclabs/hardhat-solhint');
require('dotenv').config();

const { WALLET_PRIVATE_KEY } = process.env;
const { MUMBAI_URL } = process.env;
const { POLYGON_ZKEVM_URL } = process.env


/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.19",
  networks: {
    mumbai: {
      url: MUMBAI_URL,
      accounts: [`0x${WALLET_PRIVATE_KEY}`],
    },
    polygon_zkevm:{
      url:POLYGON_ZKEVM_URL,
      accounts:[`0x${WALLET_PRIVATE_KEY}`],
    }
  },

};
