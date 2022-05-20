require ("hardhat-deploy");
require("dotenv").config()



/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.8.7",
  networks:{
    hardhat:{
      chainId:31337,
    },
    rinkeby:{
      chainId: 4,
    },
  },
  
  namedAccounts:{
    deployer:{
      default:0,
    }
  }
};
