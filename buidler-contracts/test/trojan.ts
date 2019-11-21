import { ethers } from "@nomiclabs/buidler";
import chai from "chai";
import { deployContract, getWallets, solidity } from "ethereum-waffle";
import { parseEther, formatEther, parseUnits } from "ethers/utils"

import TrojanDaoArtifact from "../build/TrojanDao.json";
import TrojanPoolArtifact from "../build/TrojanPool.json";
import TrojanTokenArtifact from "../build/TrojanToken.json";
import CurveFunctionsArtifact from "../build/CurveFunctions.json";
import TokenMockArtifact from "../build/TokenMock.json";
import { GuildBank } from "../typechain/GuildBank";
import { TrojanDao } from "../typechain/TrojanDao";
import { TrojanPool } from "../typechain/TrojanPool";
import { TrojanToken } from "../typechain/TrojanToken";
import { CurveFunctions } from "../typechain/CurveFunctions";
import { TokenMock } from "../typechain/TokenMock";

chai.use(solidity);

const { expect } = chai;

const deploymentConfig = {
  PERIOD_DURATION_IN_SECONDS: 17280,
  VOTING_DURATON_IN_PERIODS: 35,
  GRACE_DURATON_IN_PERIODS: 35,
  ABORT_WINDOW_IN_PERIODS: 5,
  PROPOSAL_DEPOSIT: 10,
  DILUTION_BOUND: 3,
  PROCESSING_REWARD: 1,
  TOKEN_SUPPLY: 10000
};

describe("Sparkle contract", function() {
  const provider = ethers.provider;
  let [wallet, minter] = getWallets(provider);
  let trojan: TrojanDao;
  let trojanToken: TrojanToken;
  let trojanPool: TrojanPool;
  let guildBank: GuildBank;
  let tokenMock: TokenMock;
  let curveFunctions: CurveFunctions;

  beforeEach(async () => {
    // @ts-ignore
    tokenMock = await deployContract(wallet, TokenMockArtifact);
    // @ts-ignore    
    curveFunctions = await deployContract(wallet, CurveFunctionsArtifact);
    // @ts-ignore    
    trojanToken = await deployContract(wallet, TrojanTokenArtifact, [
      curveFunctions.address,
      tokenMock.address
    ]);

    // TrojanDao constructor args
    // address summoner,
    // address _approvedToken,
    // uint256 _periodDuration,
    // uint256 _votingPeriodLength,
    // uint256 _gracePeriodLength,
    // uint256 _abortWindow,
    // uint256 _proposalDeposit,
    // uint256 _dilutionBound,
    // uint256 _processingReward
    // @ts-ignore
    trojan = await deployContract(wallet, TrojanDaoArtifact, [
      wallet.address,
      trojanToken.address,
      deploymentConfig.PERIOD_DURATION_IN_SECONDS,
      deploymentConfig.VOTING_DURATON_IN_PERIODS,
      deploymentConfig.GRACE_DURATON_IN_PERIODS,
      deploymentConfig.ABORT_WINDOW_IN_PERIODS,
      deploymentConfig.PROPOSAL_DEPOSIT,
      deploymentConfig.DILUTION_BOUND,
      deploymentConfig.PROCESSING_REWARD
    ]);

    // @ts-ignore
    trojanPool = await deployContract(wallet, TrojanPoolArtifact, [trojan.address]);

    await trojanToken.functions.setTrojanPool(trojanPool.address);

    // @ts-ignore
    guildBank = await trojan.functions.guildBank();
    expect(guildBank).to.be.properAddress;
  });

  describe("Trojan", function() {
    it("Minting and burning of TROJ adds DAO tax", async function() {
      const wethToMint = parseUnits("1000", 18);
      const wethToDeposit = parseUnits("500", 18);

      // mint weth token for addresses (testing purpose)
      const wethDistributor = tokenMock.connect(wallet);
      await wethDistributor.functions.mint(minter.address, wethToMint);
      let minterWethBalance = await wethDistributor.functions.balanceOf(minter.address);
      expect(minterWethBalance).to.eq(wethToMint);

      const summoner = await trojan.functions.members(wallet.address);
      expect(summoner.exists).to.be.true;
      expect(summoner.shares).to.eq(1);

      const trojBal = await trojanToken.functions.balanceOf(wallet.address)
      expect(trojBal).to.above(0);

      // activate pool
      await trojanToken.functions.approve(trojanPool.address, parseEther("1"));
      await trojanPool.functions.activate(parseEther("1"), parseEther("1"));
      const poolSharesStarting = await trojanPool.functions.totalPoolShares();
      expect(poolSharesStarting).to.eq(parseEther("1"));
      const poolTrojBalStarting = await trojanToken.functions.balanceOf(trojanPool.address);
      expect(poolTrojBalStarting).to.above(0)
      
      // approve token transfer to contract from sender
      const minterToken = trojanToken.connect(minter);
      await minterToken.functions.approve(trojanToken.address, wethToDeposit); 
      
      // tokenResult is the amount of tokens to be minted when depositing collateral(wethToDeposit)
      // priceToMint is the collateral needed to mint tokens(tokenResult)
      // ! tokenResult should be equal to priceToMint, no ? Am I missing something there ?!
      const tokenResult = await minterToken.functions.collateralToTokenBuying(wethToDeposit);
      const priceToMint = await minterToken.functions.priceToMint(tokenResult);
      console.log(tokenResult.toString());
      console.log(priceToMint.toString());

      
      // mint TROJ
      await minterToken.functions.mintTrojan(wethToDeposit)
      const minterTrojBalanceStarting = await minterToken.functions.balanceOf(minter.address);
      expect(minterTrojBalanceStarting).to.above(0);

      // check dao tax was received and shares were granted to the contract
      const daoTaxSharesAfterMint = await trojanPool.functions.donors(trojanToken.address);
      expect(daoTaxSharesAfterMint).to.above(0);
      
      // burn TROJ
      await minterToken.functions.sellTrojan(minterTrojBalanceStarting);
      const minterTrojBalanceEnding = await minterToken.functions.balanceOf(minter.address);
      expect(minterTrojBalanceEnding).to.eq(0);

      // check dao tax was received and shares were granted to the contract
      const daoTaxSharesAfterBurn = await trojanPool.functions.donors(trojanToken.address);
      expect(daoTaxSharesAfterBurn).to.above(daoTaxSharesAfterMint);
    });
  });
});
