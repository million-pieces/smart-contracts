const { expect } = require("chai");
const {
  BN,           // Big Number support
  constants,    // Common constants, like the zero address and largest integers
  expectEvent,  // Assertions for emitted events
  expectRevert, // Assertions for transactions that should fail
  time,
} = require("@openzeppelin/test-helpers");


describe("MillionPieces UNIT tests", function() {
  let Auction, MillionPieces, UniswapOracle, auction, millionPieces, uniswapOracle, MINTER_ROLE, DEVELOPER_ROLE
  let deployer, admin, developer, fund, user

  it("Deploy contracts", async () => {
    Auction = await ethers.getContractFactory("Auction");
    MillionPieces = await ethers.getContractFactory("MillionPieces");
    UniswapOracle = await ethers.getContractFactory("TestUniswapOracle");

    ADMIN_ROLE = "0x0000000000000000000000000000000000000000000000000000000000000000";
    MINTER_ROLE = "0x9f2df0fed2c77648de5860a4cc508cd0818c85b8b8a1ab4ceeef8d981c8956a6";
    DEVELOPER_ROLE = "0x4504b9dfd7400a1522f49a8b4a100552da9236849581fd59b7363eb48c6a474c";

    [ deployer, admin, developer, fund, user ] = await ethers.getSigners();

    millionPieces = await MillionPieces.deploy(await developer.getAddress());
    await millionPieces.deployed();

    uniswapOracle = await UniswapOracle.deploy();
    await uniswapOracle.deployed();

    auction = await Auction.deploy(millionPieces.address, await fund.getAddress());
    await auction.deployed();

    // Grant provided address as admin
    await millionPieces.grantRole(ADMIN_ROLE, admin.address);

    // Grant auction contract as minter
    await millionPieces.grantRole(MINTER_ROLE, auction.address);

    // Renounce deployer ownership
    await millionPieces.renounceRole(ADMIN_ROLE, deployer.address);
  })

  describe("- Million pieces NFT contract", async () => {
    it("- Check the initial world (The World)", async () => {
      const worldName = await millionPieces.getWorld(0);
      expect(worldName).to.equal("The World");
    })

    it("- Check the initial roles", async () => {
      expect(await millionPieces.hasRole(ADMIN_ROLE, await admin.getAddress())).to.equal(true);
      expect(await millionPieces.hasRole(ADMIN_ROLE, await developer.getAddress())).to.equal(false);
      expect(await millionPieces.hasRole(ADMIN_ROLE, await fund.getAddress())).to.equal(false);
      expect(await millionPieces.hasRole(ADMIN_ROLE, await user.getAddress())).to.equal(false);

      expect(await millionPieces.hasRole(MINTER_ROLE, auction.address)).to.equal(true);
      expect(await millionPieces.hasRole(MINTER_ROLE, await admin.getAddress())).to.equal(false);
      expect(await millionPieces.hasRole(MINTER_ROLE, await developer.getAddress())).to.equal(false);
      expect(await millionPieces.hasRole(MINTER_ROLE, await fund.getAddress())).to.equal(false);
      expect(await millionPieces.hasRole(MINTER_ROLE, await user.getAddress())).to.equal(false);

      expect(await millionPieces.hasRole(DEVELOPER_ROLE, await admin.getAddress())).to.equal(false);
      expect(await millionPieces.hasRole(DEVELOPER_ROLE, await developer.getAddress())).to.equal(true);
      expect(await millionPieces.hasRole(DEVELOPER_ROLE, await fund.getAddress())).to.equal(false);
      expect(await millionPieces.hasRole(DEVELOPER_ROLE, await user.getAddress())).to.equal(false);
    })

    it("- Test developer functions", async () => {
      // Switch to non allowed wallet
      millionPieces = millionPieces.connect(user);
      const demoUri = "https://api.millionpieces.io";

      await expectRevert(
        millionPieces.setTokenURI(5, demoUri),
        "setTokenURI: Unauthorized access!",
      );

      await expectRevert(
        millionPieces.setBaseURI(demoUri),
        "setBaseURI: Unauthorized access!",
      );

      // Switch to developer wallet
      millionPieces = millionPieces.connect(developer);

      // Check the current state
      let baseUri = await millionPieces.baseURI();
      expect(baseUri).to.equal("");

      // Set new base URI
      await millionPieces.setBaseURI(demoUri);

      // Check the new state
      baseUri = await millionPieces.baseURI();
      expect(baseUri).to.equal(demoUri);

      // Should revert for not created token
      await expectRevert(
        millionPieces.setTokenURI(5, demoUri),
        "ERC721Metadata: URI set of nonexistent token",
      );
    })
  })

  it("- Auction contract", async () => {

  })
})