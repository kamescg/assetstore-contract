

import { ethers } from "hardhat";
import { multiAssets } from "../assets/multi";
import { deploy } from "../utils/deploy";

async function main() {
  const { assetStore, materialToken } = await deploy();
  const [owner] = await ethers.getSigners();

  const asset = multiAssets[0];
  asset.soulbound = owner.address;
  const tx = await materialToken.mint(asset, 0);
  await tx.wait();
  const uri = await materialToken.tokenURI(0);
  const data = atob(uri.substring(29));
  const json = JSON.parse(data);
  const imageData = json.image.substring(26);
  console.log(atob(imageData));
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});