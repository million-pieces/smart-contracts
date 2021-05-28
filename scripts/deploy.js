const { network } = require("hardhat");
const hre = require("hardhat");

async function main() {
  const {
    FUND_ADDRESS,
    ADMIN_ADDRESS,
    DEVELOPER_ADDRESS
  } = process.env;

  const OPENSEA_PROXY = network.name === "rinkeby" ? "0xf57b2c51ded3a29e6891aba85459d600256cf317" : "0xa5409ec958c83c3f309868babaca7c86dcb077c1"
  const MINTER_ROLE = '0x9f2df0fed2c77648de5860a4cc508cd0818c85b8b8a1ab4ceeef8d981c8956a6';
  const DEVELOPER_ROLE = '0x2714cbbaddbb71bcae9366d8bf7770636ec7ae63227b573986d2f54fffacb39d';
  const PRIVILEGED_MINTER_ROLE = '0xc89ab2d8367031dc8496e17d5f8e7d7fe3b7217d410ed35bac16a37132b4be2f';

  const Auction = await hre.ethers.getContractFactory("Auction");
  const MillionPieces = await hre.ethers.getContractFactory("MillionPieces");
  const PieceToken = await hre.ethers.getContractFactory("Piece");
  const Airdrop = await hre.ethers.getContractFactory("Airdrop");
  console.log("Starting deployment ...");

  // Deploy MillionPieces NFT contract
  const millionPieces = await MillionPieces.deploy(OPENSEA_PROXY);
  await millionPieces.deployed();
  console.log("MillionPieces NFT address:", millionPieces.address);

  // Add auction as a minter
  await millionPieces.grantRole(MINTER_ROLE, ADMIN_ADDRESS);
  console.log("Minter added (auction)!");

  // Add auction as a minter
  await millionPieces.grantRole(PRIVILEGED_MINTER_ROLE, ADMIN_ADDRESS);
  console.log("Privileged Minter added!");

  // Add auction as a minter
  await millionPieces.grantRole(DEVELOPER_ROLE, DEVELOPER_ADDRESS);
  console.log("Developer added!");

  // Deploy Auction contract
  const auction = await Auction.deploy(millionPieces.address, FUND_ADDRESS, OPENSEA_PROXY);
  await auction.deployed();
  console.log("Auction address:", auction.address);

  // Add auction as a minter
  await millionPieces.grantRole(MINTER_ROLE, auction.address);
  console.log("Minter added (auction)!");

  // Deploy PIECE contract
  const pieceToken = await PieceToken.deploy(ADMIN_ADDRESS);
  await pieceToken.deployed();
  console.log("PIECE address:", pieceToken.address);

  // Deploy Airdrop contract
  const airdrop = await Airdrop.deploy();
  await airdrop.deployed();
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
