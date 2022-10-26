// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
  const Token = await ethers.getContractFactory("Token");
  const token = await Token.deploy("TokenAMM", "TKAMM");
  await token.deployed();

  const tokenA = await Token.deploy("TokenA", "TKA");
  await tokenA.deployed();

  const tokenB = await Token.deploy("TokenB", "TKB");
  await tokenB.deployed();

  const AMM = await ethers.getContractFactory("LiftAMM");
  const amm = await AMM.deploy(tokenA.address, tokenB.address);
  await amm.deployed();

  console.log(`Endereços: ${token.address}, ${amm.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
