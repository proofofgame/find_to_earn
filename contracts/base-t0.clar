;; Constants and Errors
(define-constant CONTRACT-OWNER tx-sender)
(define-constant BURN-WALLET 'ST5EDWN88FN8Q6A1MQ0N7SKKAG0VZ0ZQ9MXZCEJK)
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-SALE-NOT-ACTIVE (err u101))
(define-constant ERR-NOT-OWNER (err u102))

;; Variables
(define-data-var sale-active bool false)
(define-data-var factor uint u1)

;; Set public sale flag (only contract owner)
(define-public (flip-sale)
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (var-set sale-active (not (var-get sale-active)))
    (ok (var-get sale-active))))

;; Set factor (only contract owner)
(define-public (set-factor (value uint))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (var-set factor value)
    (ok true)))

;; Burn some amount of token (only contract owner)
(define-public (burn-token-supply (some-value uint))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (try! (contract-call? .token mint some-value tx-sender))
    (try! (contract-call? .token burn some-value tx-sender))
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

;; Burn 1 NFT / Phase 1
(define-public (burn-nft-phase-1 (id uint))
  (begin
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase1-t0 get-owner id) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (try! (contract-call? .phase1-t0 transfer id tx-sender BURN-WALLET))
      (try! (contract-call? .token mint (* (var-get factor) u1000000) tx-sender))
      (ok true)))

;; Burn 1 NFT / Phase 2
(define-public (burn-nft-phase-2 (id uint))
  (begin
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase2-t0 get-owner id) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (try! (contract-call? .phase2-t0 transfer id tx-sender BURN-WALLET))
      (try! (contract-call? .token mint (* (var-get factor) u5000000) tx-sender))
      (ok true)))

;; Burn 5 NFTs / Phase 1
(define-public (burn-phase-1 (id1 uint) (id2 uint) (id3 uint) (id4 uint) (id5 uint))
  (begin
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase1-t0 get-owner id1) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase1-t0 get-owner id2) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase1-t0 get-owner id3) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase1-t0 get-owner id4) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase1-t0 get-owner id5) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (try! (contract-call? .phase1-t0 transfer id1 tx-sender BURN-WALLET))
      (try! (contract-call? .phase1-t0 transfer id2 tx-sender BURN-WALLET))
      (try! (contract-call? .phase1-t0 transfer id3 tx-sender BURN-WALLET))
      (try! (contract-call? .phase1-t0 transfer id4 tx-sender BURN-WALLET))
      (try! (contract-call? .phase1-t0 transfer id5 tx-sender BURN-WALLET))
      (try! (contract-call? .phase2-t0 mint tx-sender))
      (ok true)))

;; Burn 5 NFTs / Phase 2
(define-public (burn-phase-2 (id1 uint) (id2 uint) (id3 uint) (id4 uint) (id5 uint))
  (begin
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase2-t0 get-owner id1) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase2-t0 get-owner id2) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase2-t0 get-owner id3) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase2-t0 get-owner id4) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase2-t0 get-owner id5) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (try! (contract-call? .phase2-t0 transfer id1 tx-sender BURN-WALLET))
      (try! (contract-call? .phase2-t0 transfer id2 tx-sender BURN-WALLET))
      (try! (contract-call? .phase2-t0 transfer id3 tx-sender BURN-WALLET))
      (try! (contract-call? .phase2-t0 transfer id4 tx-sender BURN-WALLET))
      (try! (contract-call? .phase2-t0 transfer id5 tx-sender BURN-WALLET))
      (try! (contract-call? .phase3-t0 mint tx-sender))
      (ok true)))

;; Claim NFT
(define-private (claim)
  (begin
    (public-mint tx-sender)))

;; Internal - Mint NFT via public sale
(define-private (public-mint (new-owner principal))
  (begin
    (asserts! (var-get sale-active) ERR-SALE-NOT-ACTIVE)
    (try! (contract-call? .phase1-t0 mint new-owner))
    (ok true)))

;; Register this contract as allowed to mint
(as-contract (contract-call? .phase1-t0 set-mint-address))
(as-contract (contract-call? .phase2-t0 set-mint-address))
(as-contract (contract-call? .token set-mint-address))