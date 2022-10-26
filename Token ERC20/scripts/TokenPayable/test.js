// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
  const initialMint = hre.ethers.utils.parseEther("978");
  const [owner, secondAccount] = await hre.ethers.getSigners();

  const TokenContract = await hre.ethers.getContractFactory("MobTokenPayable");
  const TokenDeploy = await TokenContract.deploy(initialMint);

  await TokenDeploy.deployed();

  let ownerBalance = await TokenDeploy.balanceOf(owner.address);
  let secondAccountBalance = await TokenDeploy.balanceOf(secondAccount.address);

  console.log(`${initialMint} de supply inicial para o contrato ${TokenDeploy.address} \n`);

  console.log(`Balance do deployer: ${ownerBalance} de endereço ${owner.address}\n`);
  console.log(`Balance da outra conta: ${secondAccountBalance} de endereço ${secondAccount.address}\n`);

  await TokenDeploy.connect(secondAccount).buyToken({
    value: ethers.utils.parseEther("1.0"),
  });

  ownerBalance = await TokenDeploy.balanceOf(owner.address);
  secondAccountBalance = await TokenDeploy.balanceOf(secondAccount.address);

  console.log(`Balance do deployer: ${ownerBalance} de endereço ${owner.address}\n`);
  console.log(`Balance da outra conta: ${secondAccountBalance} de endereço ${secondAccount.address}\n`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
