# Skullcoin Storyline

### Base Contract

All operations performed by the user in the web interface (on the website) are executed in this contract.

Contract Address: 

### NFT Contracts

Phase 1 Contract Address: 

Phase 2 Contract Address: 

Phase 3 Contract Address: 

Phase 4 Contract Address: 

Phase 5 Contract Address: 

### Functions

**Public**

flip-sale: Toggles the sale state. Only callable by the contract owner.

set-factor: Sets the multiplier for the number of tokens received after claiming treasure. Only callable by the contract owner.

burn-token-supply: Burns a specified amount of tokens. Only callable by the contract owner.

claim-five: Mints 5 NFTs.

claim-treasure-phase-1: Checks the chest at the first rarity level.

claim-treasure-phase-2: Checks the chest at the second rarity level.

claim-treasure-phase-3: Checks the chest at the third rarity level.

claim-treasure-phase-4: Checks the chest at the fourth rarity level.

claim-treasure-phase-5: Checks the chest at the fifth rarity level.

burn-phase-1: Burns 5 NFTs of the first level.

burn-phase-2: Burns 5 NFTs of the second level.

burn-phase-3: Burns 5 NFTs of the third level.

burn-phase-4: Burns 5 NFTs of the fourth level.

burn-phase-5: Burns 5 NFTs of the fifth level.

**Private**

claim: Mints 1 NFT. Used internally in claim-five.

mint: Called within claim during active sales.

pick-id: Single number peak from VRF.

set-vrf: Setting a new VRF hash.

**Internal Calls**

as-contract: Registers the minting address for NFT contracts.

# Made with :heart:
