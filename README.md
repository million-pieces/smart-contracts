World, NFT, PIECE, Auction and rest smart contracts of Million Pieces application 🌟

# Deployed addresses

## Mainnet:
|   Contract name            | Address                                       |
|:---------------------------|:----------------------------------------------|
| NFT address                | N/A     |
| PIECE address              | N/A     |
| Auction address            | N/A     |
| Airdrop address            | N/A     |


## Goerli:

|   Contract name            | Address                                       |
|:---------------------------|:----------------------------------------------|
| NFT address                | N/A     |
| PIECE address              | N/A     |
| Auction address            | N/A     |
| Airdrop address            | N/A     |


# Installation and Setup

### Install

Clone this repository: <br>
`git clone https://github.com/million-pieces/smart-contracts.git`

Install dependencies: <br>
`cd smart-contracts && npm install`

### Tests

The project uses [HardHat](https://hardhat.org/), so all additional methods and plugins can bee found on their [documentation](https://hardhat.org/getting-started/).  <br><br>
For UNIT tests run: <br>
`npm run test`


### Deploy

Before running deployment save the project wallet address, who should be the owner and receive mock tokens. For saving that address open `scripts/deploy.[network].js` file and save `PROJECT_OWNER` to real address. For production deployment als ogo to `toll-bridge-contract/hardhat.config.js` file and save your private key on `PRODUCTION_PRIVATE_KEY`.<br>

For reploy run: <br>
`npx hardhat run scripts/deploy.[NETWORK].js --network [NETWORK]`


#### Verification on Etherscan

After deployment run this commands:<br>

`npx hardhat verify --network [NETWORK_NAME] [NFT_CONTRACT_ADDRESS] "[DEVELOPER_ADDRESS]"` <br>
`npx hardhat verify --network [NETWORK_NAME] [AUCTION_CONTRACT_ADDRESS] "[NFT_CONTRACT_ADDRESS]" "[FUND_RECEIVER_ADDRESS]"` <br>
`npx hardhat verify --network [NETWORK_NAME] [PIECE_CONTRACT_ADDRESS] "[TOKEN_RECEIVER_ADDRESS]"` <br>
`npx hardhat verify --network [NETWORK_NAME] [AIRDROP_CONTRACT_ADDRESS]`
