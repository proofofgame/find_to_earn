# Skullcoin Storyline

Base Contract:

All operations performed by the user in the web interface (on the website) are executed in this contract.

Contract Address: ST3T54N6G4HN7GPBCYMSDKP4W00C45X19GNH7C0T6.base-test-t1

Token Contract:

Contract Address: ST3T54N6G4HN7GPBCYMSDKP4W00C45X19GNH7C0T6.token-test-t1

NFT Contracts:

Phase 1:
Contract Address: ST3T54N6G4HN7GPBCYMSDKP4W00C45X19GNH7C0T6.phase1-test-t1

Phase 2:
Contract Address: ST3T54N6G4HN7GPBCYMSDKP4W00C45X19GNH7C0T6.phase2-test-t1

Phase 3:
Contract Address: ST3T54N6G4HN7GPBCYMSDKP4W00C45X19GNH7C0T6.phase3-test-t1

Phase 4:
Contract Address: ST3T54N6G4HN7GPBCYMSDKP4W00C45X19GNH7C0T6.phase4-test-t1

Phase 5:
Contract Address: ST3T54N6G4HN7GPBCYMSDKP4W00C45X19GNH7C0T6.phase5-test-t1

Phase 6:
Contract Address: ST3T54N6G4HN7GPBCYMSDKP4W00C45X19GNH7C0T6.phase6-test-t1

Functions:

Public

flip-sale: Toggles the sale state. Only callable by the contract owner.

set-factor: Sets the multiplier for the number of tokens received after claiming treasure. Only callable by the contract owner.

burn-token-supply: Burns a specified amount of tokens. Only callable by the contract owner.

claim-five: Mints 5 NFTs.

claim-treasure-phase-1: Checks the chest at the first rarity level.

claim-treasure-phase-2: Checks the chest at the second rarity level.

claim-treasure-phase-3: Checks the chest at the third rarity level.

claim-treasure-phase-4: Checks the chest at the fourth rarity level.

claim-treasure-phase-5: Checks the chest at the fifth rarity level.

claim-treasure-phase-6: Checks the chest at the sixth rarity level.

burn-phase-1: Burns 5 NFTs of the first level.

burn-phase-2: Burns 5 NFTs of the second level.

burn-phase-3: Burns 5 NFTs of the third level.

burn-phase-4: Burns 5 NFTs of the fourth level.

burn-phase-5: Burns 5 NFTs of the fifth level.

burn-phase-6: Burns 5 NFTs of the sixth level.

Private

claim: Mints 1 NFT. Used internally in claim-five.

public-mint: Called within claim during active sales.

Internal Calls

as-contract: Registers the minting address for NFT contracts.

# Made with :heart:
