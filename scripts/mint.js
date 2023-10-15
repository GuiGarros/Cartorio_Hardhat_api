const hre = require("hardhat");

async function main() {

  const CasaTokenFactory = await hre.ethers.getContractFactory("CasaToken");
  const CasaToken = await CasaTokenFactory.attach("0xc53Ec531B1951eB5043F7850D9a2F347b594Cc67");
  const tx = await CasaToken.mint("0xC2d3940E9b7ef2723D4E3a9aD83cB129aE1cdCd3", 1000);
  await tx.wait();

  console.log(
    `CasaToken deployed to ${CasaToken.target}`
  );
}

export default CasaToken;
// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
