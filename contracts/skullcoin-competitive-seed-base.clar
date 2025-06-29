;; Skullcoin | Competitive | Seed Phrase | v.1.0.0
;; skullco.in

;; Traits
(use-trait ft-trait 'SP3FBR2AGK5H9QBDH3EEN6DF8EK8JY7RX8QJ5SVTE.sip-010-trait-ft-standard.sip-010-trait)

;; Constants and Errors
(define-constant CONTRACT-OWNER tx-sender)
(define-constant BURN-WALLET 'SP5EDWN88FN8Q6A1MQ0N7SKKAG0VZ0ZQ9MFZ6RS8)
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-SALE-NOT-ACTIVE (err u101))
(define-constant ERR-NOT-OWNER (err u102))

;; Variables
(define-data-var sale-active bool false)
(define-data-var last-block uint u0)
(define-data-var byte-id uint u0)
(define-data-var picked-id uint u0)
(define-data-var last-vrf (buff 64) 0x00)

;; Maps

;; Check public sales active
(define-read-only (sale-enabled)
  (ok (var-get sale-active)))

;; Set public sale flag (only contract owner)
(define-public (flip-sale)
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (var-set sale-active (not (var-get sale-active)))
    (ok (var-get sale-active))))

;; Claim 1 NFT
(define-public (claim-one)
  (begin
    (try! (claim))
  (ok true)))

;; Claim 5 NFT
(define-public (claim-five)
  (begin
    (try! (claim))
    (try! (claim))
    (try! (claim))
    (try! (claim))
    (try! (claim))
  (ok true)))

;; Claim 10 NFT
(define-public (claim-ten)
  (begin
    (try! (claim))
    (try! (claim))
    (try! (claim))
    (try! (claim))
    (try! (claim))
    (try! (claim))
    (try! (claim))
    (try! (claim))
    (try! (claim))
    (try! (claim))
  (ok true)))

;; Burn 5 NFTs / Phase 1
(define-public (burn-phase-1 (id1 uint) (id2 uint) (id3 uint) (id4 uint) (id5 uint))
  (begin
    (asserts! (is-eq (unwrap! (unwrap! (contract-call? .skullcoin-competitive-seed-phase1 get-owner id1) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
    (asserts! (is-eq (unwrap! (unwrap! (contract-call? .skullcoin-competitive-seed-phase1 get-owner id2) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
    (asserts! (is-eq (unwrap! (unwrap! (contract-call? .skullcoin-competitive-seed-phase1 get-owner id3) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
    (asserts! (is-eq (unwrap! (unwrap! (contract-call? .skullcoin-competitive-seed-phase1 get-owner id4) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
    (asserts! (is-eq (unwrap! (unwrap! (contract-call? .skullcoin-competitive-seed-phase1 get-owner id5) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
    (try! (contract-call? .skullcoin-competitive-seed-phase1 transfer id1 tx-sender BURN-WALLET))
    (try! (contract-call? .skullcoin-competitive-seed-phase1 transfer id2 tx-sender BURN-WALLET))
    (try! (contract-call? .skullcoin-competitive-seed-phase1 transfer id3 tx-sender BURN-WALLET))
    (try! (contract-call? .skullcoin-competitive-seed-phase1 transfer id4 tx-sender BURN-WALLET))
    (try! (contract-call? .skullcoin-competitive-seed-phase1 transfer id5 tx-sender BURN-WALLET))
    (try! (contract-call? .skullcoin-competitive-seed-phase2 mint tx-sender))
    (try! (contract-call? .skullcoin-competitive-seed-phase2 mint tx-sender))
    (print {
      result: "nfts successfully burned",
      user: contract-caller,
      nft-1: id1,
      nft-2: id2,
      nft-3: id3,
      nft-4: id4,
      nft-5: id5
    })
  (ok true)))

;; Burn 5 NFTs / Phase 2
(define-public (burn-phase-2 (id1 uint) (id2 uint) (id3 uint) (id4 uint) (id5 uint))
  (begin
    (asserts! (is-eq (unwrap! (unwrap! (contract-call? .skullcoin-competitive-seed-phase2 get-owner id1) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
    (asserts! (is-eq (unwrap! (unwrap! (contract-call? .skullcoin-competitive-seed-phase2 get-owner id2) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
    (asserts! (is-eq (unwrap! (unwrap! (contract-call? .skullcoin-competitive-seed-phase2 get-owner id3) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
    (asserts! (is-eq (unwrap! (unwrap! (contract-call? .skullcoin-competitive-seed-phase2 get-owner id4) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
    (asserts! (is-eq (unwrap! (unwrap! (contract-call? .skullcoin-competitive-seed-phase2 get-owner id5) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
    (try! (contract-call? .skullcoin-competitive-seed-phase2 transfer id1 tx-sender BURN-WALLET))
    (try! (contract-call? .skullcoin-competitive-seed-phase2 transfer id2 tx-sender BURN-WALLET))
    (try! (contract-call? .skullcoin-competitive-seed-phase2 transfer id3 tx-sender BURN-WALLET))
    (try! (contract-call? .skullcoin-competitive-seed-phase2 transfer id4 tx-sender BURN-WALLET))
    (try! (contract-call? .skullcoin-competitive-seed-phase2 transfer id5 tx-sender BURN-WALLET))
    (print {
      result: "nfts successfully burned",
      user: contract-caller,
      nft-1: id1,
      nft-2: id2,
      nft-3: id3,
      nft-4: id4,
      nft-5: id5
    })
  (ok true)))

;; Internal - Claim NFT
(define-private (claim)
  (if (var-get wl-sale-active)
    (wl-mint tx-sender)
    (mint tx-sender)))

;; Internal - Mint NFT via public
(define-private (mint (new-owner principal))
  (begin
    (asserts! (var-get sale-active) ERR-SALE-NOT-ACTIVE)
    (try! (contract-call? .skullcoin-competitive-seed-phase1 mint new-owner))
  (ok true)))

;; Register this contract as allowed to mint
(as-contract (contract-call? .skullcoin-competitive-seed-phase1 set-mint-address))
(as-contract (contract-call? .skullcoin-competitive-seed-phase2 set-mint-address))