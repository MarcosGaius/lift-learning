// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
  const [owner] = await hre.ethers.getSigners();
  console.log("Deploying contracts with account:", owner.address);
  console.log("Account balance:", (await owner.getBalance()).toString());

  const initialMint = hre.ethers.utils.parseEther("978");

  const TokenContract = await hre.ethers.getContractFactory("MobTokenPayable");
  const TokenDeploy = await TokenContract.deploy(initialMint);

  await TokenDeploy.deployed();

  const ownerBalance = await TokenDeploy.balanceOf(owner.address);

  console.log(`${initialMint} de supply inicial para o contrato ${TokenDeploy.address} \n`);
  console.log(`Balance do deployer: ${ownerBalance} de endereço ${owner.address}\n`);
  console.log(`Dados do deployer: ${JSON.stringify(owner)}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
