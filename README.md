# Skullcoin Competitive

### Base Contract

All operations performed by the user in the web interface (on the website) are executed in this contract.

Contract Address: https://explorer.hiro.so/txid/SP3T54N6G4HN7GPBCYMSDKP4W00C45X19GQ4VT13Y.skullcoin-competitive-g1-base?chain=mainnet

### NFT Contracts

Phase 1 Contract Address: https://explorer.hiro.so/txid/SP3T54N6G4HN7GPBCYMSDKP4W00C45X19GQ4VT13Y.skullcoin-competitive-g1-phase1?chain=mainnet

Phase 2 Contract Address: https://explorer.hiro.so/txid/SP3T54N6G4HN7GPBCYMSDKP4W00C45X19GQ4VT13Y.skullcoin-competitive-g1-phase2?chain=mainnet

Phase 3 Contract Address: https://explorer.hiro.so/txid/SP3T54N6G4HN7GPBCYMSDKP4W00C45X19GQ4VT13Y.skullcoin-competitive-g1-phase3?chain=mainnet

Phase 4 Contract Address: https://explorer.hiro.so/txid/SP3T54N6G4HN7GPBCYMSDKP4W00C45X19GQ4VT13Y.skullcoin-competitive-g1-phase4?chain=mainnet

### Functions

**Public**

get-wl-balance: Get whitelist balance by address.

wl-enabled: Check whitelist sales active.

public-enabled: Check public sales active.

flip-wl-sale: Toggles the whitelist sale state. Only callable by the contract owner.

flip-sale: Toggles the public sale state. Only callable by the contract owner.

deposit-ft: Deposit SIP-010 tokens in contract. Only callable by the contract owner.

withdraw-ft: Withdrawal SIP-010 tokens from contract. Only callable by the contract owner.

deposit-stx: Deposit STX in contract. Only callable by the contract owner.

withdraw-stx: Withdrawal STX from contract. Only callable by the contract owner.

set-wl-wallets: Set whitelist wallets. Only callable by the contract owner.

set-treasure-phase-1: Setting NFT ids that gives a treasure reward at the first rarity level. Only callable by the contract owner.

set-treasure-phase-2: Setting NFT ids that gives a treasure reward at the second rarity level. Only callable by the contract owner.

set-treasure-phase-3: Setting NFT ids that gives a treasure reward at the third rarity level. Only callable by the contract owner.

set-chest-phase-1: Setting NFT ids that gives a chest reward at the first rarity level. Only callable by the contract owner.

set-chest-phase-2: Setting NFT ids that gives a chest reward at the second rarity level. Only callable by the contract owner.

set-chest-phase-3: Setting NFT ids that gives a chest reward at the third rarity level. Only callable by the contract owner.

set-tokens-phase-1: Setting NFT ids that gives a ft reward at the first rarity level. Only callable by the contract owner.

set-tokens-phase-2: Setting NFT ids that gives a ft reward at the second rarity level. Only callable by the contract owner.

set-tokens-phase-3: Setting NFT ids that gives a ft reward at the third rarity level. Only callable by the contract owner.

set-stx-phase-1: Setting NFT ids that gives a stx reward at the first rarity level. Only callable by the contract owner.

set-stx-phase-2: Setting NFT ids that gives a stx reward at the second rarity level. Only callable by the contract owner.

set-stx-phase-3: Setting NFT ids that gives a stx reward at the third rarity level. Only callable by the contract owner.

claim-one: Mints 1 NFT.

claim-five: Mints 5 NFTs.

claim-ten: Mints 10 NFTs.

claim-treasure-phase-1: Checks the treasure at the first rarity level.

claim-treasure-phase-2: Checks the treasure at the second rarity level.

claim-treasure-phase-3: Checks the treasure at the third rarity level.

claim-chest-phase-1: Checks the chest at the first rarity level.

claim-chest-phase-2: Checks the chest at the second rarity level.

claim-chest-phase-3: Checks the chest at the third rarity level.

claim-stx-phase-1: Checks the stx reward at the first rarity level.

claim-stx-phase-2: Checks the stx reward at the second rarity level.

claim-stx-phase-3: Checks the stx reward at the third rarity level.

claim-tokens-phase-1: Checks the ft reward at the first rarity level.

claim-tokens-phase-2: Checks the ft reward at the second rarity level.

claim-tokens-phase-3: Checks the ft reward at the third rarity level.

burn-phase-1: Burns 5 NFTs of the first level.

burn-phase-2: Burns 5 NFTs of the second level.

burn-phase-3: Burns 5 NFTs of the third level.

**Private**

claim: Mints 1 NFT. Used internally in claim-five.

wl-mint: Called within claim during active whitelist sales.

mint: Called within claim during active public sales.

send-stx-to-winner: Send STX to winner player in claim function for treasure/chest/stx NFTs.

send-ft-to-winner: Send SIP-010 tokens to winner player in claim function for tokens NFTs.

pick-id: Single number peak from VRF.

set-vrf: Setting a new VRF hash.

**Internal Calls**

as-contract: Registers the minting address for NFT contracts.

# Made with :heart: