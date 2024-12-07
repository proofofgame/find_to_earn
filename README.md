# Skullcoin Competitive

### Base Contract

All operations performed by the user in the web interface (on the website) are executed in this contract.

Contract Address: 

### NFT Contracts

Phase 1 Contract Address: 

Phase 2 Contract Address: 

Phase 3 Contract Address: 

Phase 4 Contract Address: 

### Functions

**Public**

flip-wl-sale: Toggles the whitelist sale state. Only callable by the contract owner.

flip-sale: Toggles the public sale state. Only callable by the contract owner.

set-factor-1: Sets the multiplier for the number of tokens received after claiming treasure. Only callable by the contract owner.

set-factor-2: Sets the multiplier for the number of tokens received after claiming chest. Only callable by the contract owner.

set-factor-3: Sets the multiplier for the number of tokens received after claiming coins. Only callable by the contract owner.

deposit-ft: Deposit SIP-010 tokens in contract. Only callable by the contract owner.

withdraw-ft: Withdrawal SIP-010 tokens from contract. Only callable by the contract owner.

send-ft: Send SIP-010 tokens to player. Only callable by the contract owner.

deposit-stx: Deposit STX in contract. Only callable by the contract owner.

withdraw-stx: Withdrawal STX from contract. Only callable by the contract owner.

send-stx: Send STX to player. Only callable by the contract owner.

set-treasure-phase-1: Setting NFT ids that gives a treasure reward at the first rarity level.

set-treasure-phase-2: Setting NFT ids that gives a treasure reward at the second rarity level.

set-treasure-phase-3: Setting NFT ids that gives a treasure reward at the third rarity level.

set-chest-phase-1: Setting NFT ids that gives a chest reward at the first rarity level.

set-chest-phase-2: Setting NFT ids that gives a chest reward at the second rarity level.

set-chest-phase-3: Setting NFT ids that gives a chest reward at the third rarity level.

set-coins-phase-1: Setting NFT ids that gives a coins reward at the first rarity level.

set-coins-phase-2: Setting NFT ids that gives a coins reward at the second rarity level.

set-coins-phase-3: Setting NFT ids that gives a coins reward at the third rarity level.

claim-one: Mints 1 NFT.

claim-two: Mints 2 NFT.

claim-three: Mints 3 NFT.

claim-four: Mints 4 NFT.

claim-five: Mints 5 NFTs.

claim-ten: Mints 10 NFTs.

claim-treasure-phase-1: Checks the treasure at the first rarity level.

claim-treasure-phase-2: Checks the treasure at the second rarity level.

claim-treasure-phase-3: Checks the treasure at the third rarity level.

claim-chest-phase-1: Checks the chest at the first rarity level.

claim-chest-phase-2: Checks the chest at the second rarity level.

claim-chest-phase-3: Checks the chest at the third rarity level.

burn-phase-1: Burns 5 NFTs of the first level.

burn-phase-2: Burns 5 NFTs of the second level.

burn-phase-3: Burns 5 NFTs of the third level.

**Private**

claim: Mints 1 NFT. Used internally in claim-five.

mint: Called within claim during active sales.

send-stx-to-winner: Send STX to winner player in claim function for treasure/chest/coins.

pick-id: Single number peak from VRF.

set-vrf: Setting a new VRF hash.

**Internal Calls**

as-contract: Registers the minting address for NFT contracts.

# Made with :heart:
