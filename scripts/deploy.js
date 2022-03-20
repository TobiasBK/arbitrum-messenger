const hre = require("hardhat");

//simple deployment
async function main() {

  const ArbitrumMessengerL1ToL2 = await hre.ethers.getContractFactory("ArbitrumMessengerL1ToL2");
  const arbitrumMessengerL1ToL2 = await ArbitrumMessengerL1ToL2.deploy(ethers.constants.AddressZero); //temp l2 addr

  await arbitrumMessengerL1ToL2.deployed();

  console.log("MessengerL1ToL2 deployed to:", arbitrumMessengerL1ToL2.address);

  const ArbitrumMessengerL2ToL1 = await hre.ethers.getContractFactory("ArbitrumMessengerL2ToL1");
  const arbitrumMessengerL2ToL1 = await ArbitrumMessengerL2ToL1.deploy(ethers.constants.AddressZero); //temp l2 addr

  await arbitrumMessengerL2ToL1.deployed();

  console.log("MessengerL2ToL1 deployed to:", arbitrumMessengerL2ToL1.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
