# Skullcoin Competitive Seed Phrase Find

### Base Contract

All operations performed by the user in the web interface (on the website) are executed in this contract.

Contract Address: 

### NFT Contracts

Phase 1 Contract Address: 

Phase 2 Contract Address: 

### Functions

**Public**

sale-enabled: Check sales active or not.

flip-sale: Toggles the public sale state. Only callable by the contract owner.

claim-one: Mints 1 NFT.

claim-five: Mints 5 NFTs.

claim-ten: Mints 10 NFTs.

burn-phase-1: Burns 5 NFTs of the first level.

burn-phase-2: Burns 5 NFTs of the second level.

**Private**

claim: Mints 1 NFT. Used internally in claim-five.

mint: Called within claim during active public sales.

**Internal Calls**

as-contract: Registers the minting address for NFT contracts.

# Made with :heart: