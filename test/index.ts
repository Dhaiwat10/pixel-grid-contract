import { expect } from "chai";
import { ethers } from "hardhat";

const setupContract = async () => {
  const PixelGrid = await ethers.getContractFactory("PixelGrid");
  const pixelGrid = await PixelGrid.deploy();
  await pixelGrid.deployed();
  return pixelGrid;
};

const getAccounts = async () => {
  const accounts = await ethers.getSigners();
  return accounts;
};

const baseURI = "ipfs://";

describe("PixelGrid", () => {
  it("mintItem()", async () => {
    const pixelGrid = await setupContract();
    const accounts = await getAccounts();
    const account = accounts[0];
    const tx = await pixelGrid.mintItem(
      account.address,
      "QmPf2x91DoemnhXSZhGDP8TX9Co8AScpvFzTuFt9BGAoBY",
      {
        value: ethers.utils.parseEther("0.0001"),
      }
    );
    const res = await tx.wait();
    // @ts-ignore
    const tokenId = res.events[0].args[2].toNumber();
    console.log(tokenId);
    const balance = await pixelGrid.balanceOf(account.address);
    expect(balance).to.equal("1");
    const tokenURI = await pixelGrid.tokenURI(tokenId);
    expect(tokenURI).to.equal(
      baseURI + "QmPf2x91DoemnhXSZhGDP8TX9Co8AScpvFzTuFt9BGAoBY"
    );

    const tx2 = await pixelGrid.changeTokenURI("1", "gm");
    await tx2.wait();
    const newTokenURI = await pixelGrid.tokenURI(tokenId);
    expect(newTokenURI).to.equal(baseURI + "gm");
  });
});
