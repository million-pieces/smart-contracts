World, NFT, PIECE, Auction and rest smart contracts of Million Pieces application 🌟

# Deployed addresses

## Mainnet:
|   Contract name            | Address                                       |
|:---------------------------|:----------------------------------------------|
| NFT address                | N/A     |
| PIECE address              | N/A     |
| Auction address            | N/A     |
| Airdrop address            | N/A     |


## Rinkeby:

|   Contract name            | Address                                       |
|:---------------------------|:----------------------------------------------|
| NFT address                | [0x2189D47aACb6934016Ea4e56B088791D8618829a](https://rinekeby.etherscan.io/address/0x2189D47aACb6934016Ea4e56B088791D8618829a)     |
| PIECE address              | [0x65CD61246B2f739c1f4aACf4Cba8503BcF6Fb6B4](https://rinekeby.etherscan.io/address/0x65CD61246B2f739c1f4aACf4Cba8503BcF6Fb6B4)     |
| Auction address            | [0xc23767072D1E6F1d3aF7fCbE114cc0C67d8Bc6f3](https://rinekeby.etherscan.io/address/0xc23767072D1E6F1d3aF7fCbE114cc0C67d8Bc6f3)     |
| Airdrop address            | [0xC70dAA87Fd64A87Eb0B5c88Eac2f7b2c643919A3](https://rinekeby.etherscan.io/address/0xC70dAA87Fd64A87Eb0B5c88Eac2f7b2c643919A3)     |


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

`npx hardhat verify --network [NETWORK_NAME] [NFT_CONTRACT_ADDRESS] "[PROXY_REGISTER_ADDRESS]"` <br>
`npx hardhat verify --network [NETWORK_NAME] [AUCTION_CONTRACT_ADDRESS] "[NFT_CONTRACT_ADDRESS]" "[FUND_RECEIVER_ADDRESS]" "[PROXY_REGISTER_ADDRESS]"` <br>
`npx hardhat verify --network [NETWORK_NAME] [PIECE_CONTRACT_ADDRESS] "[TOKEN_RECEIVER_ADDRESS]"` <br>
`npx hardhat verify --network [NETWORK_NAME] [AIRDROP_CONTRACT_ADDRESS]`
