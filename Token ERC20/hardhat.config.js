require("@nomicfoundation/hardhat-toolbox");

const ALCHEMY_API_KEY = "";
const GOERLI_PRIVATE_KEY = "";

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.9",
  networks: {
    goerli: {
      url: `https://polygon-mumbai.g.alchemy.com/v2/l4TjcT40bQ1MXo_f_Cmju4ZKhLPYSRtL`,
      accounts: [GOERLI_PRIVATE_KEY],
    },
  },
};
