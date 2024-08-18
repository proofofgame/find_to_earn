# Skullcoin Storyline

### Base Contract

All operations performed by the user in the web interface (on the website) are executed in this contract.

Contract Address: https://explorer.hiro.so/txid/ST3T54N6G4HN7GPBCYMSDKP4W00C45X19GNH7C0T6.base-test-t3?chain=testnet

### NFT Contracts

Phase 1 Contract Address: https://explorer.hiro.so/txid/ST3T54N6G4HN7GPBCYMSDKP4W00C45X19GNH7C0T6.phase1-test-t3?chain=testnet

Phase 2 Contract Address: https://explorer.hiro.so/txid/ST3T54N6G4HN7GPBCYMSDKP4W00C45X19GNH7C0T6.phase2-test-t3?chain=testnet

Phase 3 Contract Address: https://explorer.hiro.so/txid/ST3T54N6G4HN7GPBCYMSDKP4W00C45X19GNH7C0T6.phase3-test-t3?chain=testnet

Phase 4 Contract Address: https://explorer.hiro.so/txid/ST3T54N6G4HN7GPBCYMSDKP4W00C45X19GNH7C0T6.phase4-test-t3?chain=testnet

### Functions

**Public**

flip-sale: Toggles the sale state. Only callable by the contract owner.

set-factor: Sets the multiplier for the number of tokens received after claiming treasure. Only callable by the contract owner.

deposit-ft: Deposit SIP-010 tokens in contract. Only callable by the contract owner.

withdraw-ft: Withdrawal SIP-010 tokens from contract. Only callable by the contract owner.

send-ft: Send SIP-010 tokens to player. Only callable by the contract owner.

deposit-stx: Deposit STX in contract. Only callable by the contract owner.

withdraw-stx: Withdrawal STX from contract. Only callable by the contract owner.

send-stx: Send STX to player. Only callable by the contract owner.

set-treasure-phase-1: Setting NFT ids that gives a chest reward at the first rarity level.

set-treasure-phase-2: Setting NFT ids that gives a chest reward at the second rarity level.

set-treasure-phase-3: Setting NFT ids that gives a chest reward at the third rarity level.

set-coins-phase-1: Setting NFT ids that gives a coins reward at the first rarity level.

set-coins-phase-2: Setting NFT ids that gives a coins reward at the second rarity level.

set-coins-phase-3: Setting NFT ids that gives a coins reward at the third rarity level.

claim-five: Mints 5 NFTs.

claim-treasure-phase-1: Checks the chest at the first rarity level.

claim-treasure-phase-2: Checks the chest at the second rarity level.

claim-treasure-phase-3: Checks the chest at the third rarity level.

claim-coins-phase-1: Checks the coins at the first rarity level.

claim-coins-phase-2: Checks the coins at the second rarity level.

claim-coins-phase-3: Checks the coins at the third rarity level.

burn-phase-1: Burns 5 NFTs of the first level.

burn-phase-2: Burns 5 NFTs of the second level.

burn-phase-3: Burns 5 NFTs of the third level.

**Private**

claim: Mints 1 NFT. Used internally in claim-five.

mint: Called within claim during active sales.

pick-id: Single number peak from VRF.

set-vrf: Setting a new VRF hash.

**Internal Calls**

as-contract: Registers the minting address for NFT contracts.

# Made with :heart: