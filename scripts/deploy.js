const hre = require("hardhat");

async function main() {
 const voting = await hre.ethers.deployContract("Voting");
 voting.waitForDeployment();
 console.log(`Deployed contract is:${voting.target}`);
}
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
