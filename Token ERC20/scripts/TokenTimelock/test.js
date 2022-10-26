// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
  const initialMint = hre.ethers.utils.parseEther("978");
  const [owner, otherAccount] = await hre.ethers.getSigners();
  console.log("~ otherAccount", otherAccount.address);

  const TokenContract = await hre.ethers.getContractFactory("MobTokenTimelock");
  const TokenDeploy = await TokenContract.deploy(initialMint);

  await TokenDeploy.deployed();

  const ownerBalance = await TokenDeploy.balanceOf(owner.address);

  console.log(`${initialMint} de supply inicial para o contrato ${TokenDeploy.address} \n`);
  console.log(`Balance do deployer: ${ownerBalance} de endereço ${owner.address}\n`);

  await TokenDeploy.transfer(otherAccount.address, 1000000);
  const otherAccountBalance = await TokenDeploy.balanceOf(otherAccount.address);

  console.log(`Balance da outra conta: ${otherAccountBalance} de endereço ${otherAccount.address}\n`);

  await TokenDeploy.connect(otherAccount).transfer(owner.address, 1000000);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
