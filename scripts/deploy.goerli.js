const hre = require("hardhat");

async function main() {
  const {
    FUND_ADDRESS,
    ADMIN_ADDRESS,
    DEVELOPER_ADDRESS,
    DEVELOPMENT_WALLET
  } = process.env;

  // Constant contract addresses (outdated)
  const USDC_ADDRESS = "0xD87Ba7A50B2E7E660f678A895E4B72E7CB4CCd9C";
  const WETH_ADDRESS = "0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6";
  const UNISWAP_FACTORY = "0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f";

  // Roles
  const MINTER_ROLE = '0x9f2df0fed2c77648de5860a4cc508cd0818c85b8b8a1ab4ceeef8d981c8956a6';
  const DEFAULT_ADMIN_ROLE = '0x0000000000000000000000000000000000000000000000000000000000000000';

  const Auction = await hre.ethers.getContractFactory("Auction");
  const MillionPieces = await hre.ethers.getContractFactory("MillionPieces");
  const PieceToken = await hre.ethers.getContractFactory("Piece");
  const Airdrop = await hre.ethers.getContractFactory("Airdrop");
  const UniswapOracle = await hre.ethers.getContractFactory("UniswapOracle");
  console.log("Starting deployment on Goerli network ...");

  // Deploy MillionPieces NFT contract
  const millionPieces = await MillionPieces.deploy(DEVELOPER_ADDRESS);
  await millionPieces.deployed();
  console.log("Million Pieces NFT contract is done!");

  // // Deploy Auction contract
  const auction = await Auction.deploy(millionPieces.address, FUND_ADDRESS);
  await auction.deployed();
  console.log("Auction is done!");

  // Add auction as a minter
  await millionPieces.grantRole(MINTER_ROLE, auction.address);
  console.log("Minter added!");

  // Transfer ownership to admin
  await millionPieces.grantRole(DEFAULT_ADMIN_ROLE, ADMIN_ADDRESS);
  console.log("Admin added!");

  // Renounce deployer ownership
  await millionPieces.renounceRole(DEFAULT_ADMIN_ROLE, DEVELOPMENT_WALLET);
  console.log("Deployer role renounced!");

  // Deploy PIECE contract
  const pieceToken = await PieceToken.deploy(ADMIN_ADDRESS);
  await millionPieces.deployed();
  console.log("Piece contract is done!");

  // Deploy Airdrop contract
  const airdrop = await Airdrop.deploy();
  await airdrop.deployed();
  console.log("Airdrop contract is done!");

  console.log("--------------")
  console.log("MillionPieces NFT address:", millionPieces.address);
  console.log("Auction address:", auction.address);
  console.log("PIECE address:", pieceToken.address);
  console.log("Airdrop address:", airdrop.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
