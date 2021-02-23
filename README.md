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
| NFT address                | [0x58ADD7e59b348e3607837FAD6f2a7fC8CA144685](https://goerli.etherscan.io/address/0x58ADD7e59b348e3607837FAD6f2a7fC8CA144685)     |
| PIECE address              | [0x349943c818784A6aA9E7586dc94303FAb14768a2](https://goerli.etherscan.io/address/0x349943c818784A6aA9E7586dc94303FAb14768a2)     |
| Auction address            | [0xf0FE673787eaa77f0f0ED8E537Db48F9eB82bFA9](https://goerli.etherscan.io/address/0xf0FE673787eaa77f0f0ED8E537Db48F9eB82bFA9)     |
| Airdrop address            | [0x386be6346dBF3c5bDA1cC48B7048Ce27297b3525](https://goerli.etherscan.io/address/0x386be6346dBF3c5bDA1cC48B7048Ce27297b3525)     |


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

Before running deployment please check the `.env.example` file, copy it, rename to `.env` and fill all values there. 2 networks are supported now, mainnet and goerli. For deploy run: <br>
`npm run deploy:[NETWORK]`


#### Verification on Etherscan

After deployment run this commands:<br>

`npx hardhat verify --network [NETWORK_NAME] [NFT_CONTRACT_ADDRESS] "[DEVELOPER_ADDRESS]"` <br>
`npx hardhat verify --network [NETWORK_NAME] [AUCTION_CONTRACT_ADDRESS] "[NFT_CONTRACT_ADDRESS]" "[FUND_RECEIVER_ADDRESS]"` <br>
`npx hardhat verify --network [NETWORK_NAME] [PIECE_CONTRACT_ADDRESS] "[TOKEN_RECEIVER_ADDRESS]"` <br>
`npx hardhat verify --network [NETWORK_NAME] [AIRDROP_CONTRACT_ADDRESS]`
