# Skullcoin Treasure Hunt

Skullcoin introduces a unique Find-to-Earn concept, creating a GameFi with a sustainable economy, focusing on skill-based treasure hunting powered by meritocratic tokenomics.
This Web3 game innovates Encrypted NFTs (eNFTs) with two layers of information: public and private, to embed secret clues for players to discover, emphasizing strategy and collaboration.
The Proof-of-Game mechanism rewards players for their problem-solving skills, ensuring an equitable distribution of skullcoins without premine. On-chain mechanics based on Verifiable Random Function (VRF) ensure fairness in randomness. Designed to be resistant to AI, Skullcoin maintains a fair competition environment, promoting human creativity and interaction.
Beyond entertainment, it serves as an educational platform on blockchain and digital currencies, fostering a community of learners and adventurers, and leading to the mass adoption of cryptocurrencies. Through engaging gameplay and a focus on merit, Skullcoin aims to blend gaming with educational insights into blockchain technology.
In Skullcoin's universe, where NFTs gain new life and purpose through narrative-driven quests, digital tokens showcase intrinsic value. In Find-to-Earn, the coordinates that players need to find are akin to the target hash in Bitcoin but only for human minds.

## Clarity

The base contract through which the entire game is managed - https://explorer.hiro.so/txid/ST3T54N6G4HN7GPBCYMSDKP4W00C45X19GNH7C0T6.base-test-t0?chain=testnet

Mint 5 NFTs. Called without any parameters. Use private function `claim`.
```
(define-public (claim-five)
  (begin
    (try! (claim))
    (try! (claim))
    (try! (claim))
    (try! (claim))
    (try! (claim))
    (ok true)))
```

Checking a treasure at the first-level NFT. One NFT id with a picture of the chest is transmitted. Basically these are numbers 5,10,15 and so.
```
(define-public (claim-treasure-phase-1 (id uint))
  (begin
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase1-test-t0 get-owner id) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (asserts! (is-eq (mod id u5) u0) ERR-NOT-TREASURE)
      (try! (contract-call? .token-test mint (* (var-get factor) u1000000) tx-sender))
      (ok true)))
```

Checking a treasure at the second-level NFT. One NFT id with a picture of the chest is transmitted. Similarly first-level.
```
(define-public (claim-treasure-phase-2 (id uint))
  (begin
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase2-test-t0 get-owner id) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (asserts! (is-eq (mod id u5) u0) ERR-NOT-TREASURE)
      (try! (contract-call? .token-test mint (* (var-get factor) u5000000) tx-sender))
      (ok true)))
```


Burning 5 NFTs at the first-level. 5 id (id1, id2, ...) NFT are transferred. At the exit, the user will receive 5 NFTs of the second-level.
```
(define-public (burn-phase-1 (id1 uint) (id2 uint) (id3 uint) (id4 uint) (id5 uint))
  (begin
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase1-test-t0 get-owner id1) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase1-test-t0 get-owner id2) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase1-test-t0 get-owner id3) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase1-test-t0 get-owner id4) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase1-test-t0 get-owner id5) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (try! (contract-call? .phase1-test-t0 transfer id1 tx-sender BURN-WALLET))
      (try! (contract-call? .phase1-test-t0 transfer id2 tx-sender BURN-WALLET))
      (try! (contract-call? .phase1-test-t0 transfer id3 tx-sender BURN-WALLET))
      (try! (contract-call? .phase1-test-t0 transfer id4 tx-sender BURN-WALLET))
      (try! (contract-call? .phase1-test-t0 transfer id5 tx-sender BURN-WALLET))
      (try! (contract-call? .phase2-test-t0 mint tx-sender))
      (try! (contract-call? .phase2-test-t0 mint tx-sender))
      (try! (contract-call? .phase2-test-t0 mint tx-sender))
      (try! (contract-call? .phase2-test-t0 mint tx-sender))
      (try! (contract-call? .phase2-test-t0 mint tx-sender))
      (ok true)))
```

Burning of 5 NFTs at the second-level. 5 id (id1, id2, ...) NFT are transferred. At the exit, the user will simply empty his wallet.
```
(define-public (burn-phase-2 (id1 uint) (id2 uint) (id3 uint) (id4 uint) (id5 uint))
  (begin
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase2-test-t0 get-owner id1) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase2-test-t0 get-owner id2) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase2-test-t0 get-owner id3) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase2-test-t0 get-owner id4) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase2-test-t0 get-owner id5) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (try! (contract-call? .phase2-test-t0 transfer id1 tx-sender BURN-WALLET))
      (try! (contract-call? .phase2-test-t0 transfer id2 tx-sender BURN-WALLET))
      (try! (contract-call? .phase2-test-t0 transfer id3 tx-sender BURN-WALLET))
      (try! (contract-call? .phase2-test-t0 transfer id4 tx-sender BURN-WALLET))
      (try! (contract-call? .phase2-test-t0 transfer id5 tx-sender BURN-WALLET))
      (ok true)))
```

First-level NFT contract - https://explorer.hiro.so/txid/ST3T54N6G4HN7GPBCYMSDKP4W00C45X19GNH7C0T6.phase1-test-t0?chain=testnet
Second-level NFT contract - https://explorer.hiro.so/txid/ST3T54N6G4HN7GPBCYMSDKP4W00C45X19GNH7C0T6.phase2-test-t0?chain=testnet
Token contract - https://explorer.hiro.so/txid/ST3T54N6G4HN7GPBCYMSDKP4W00C45X19GNH7C0T6.token-test?chain=testnet

# Made with :heart: