;; Storage
(define-map presale-count principal uint)

;; Constats and Errors
(define-constant CONTRACT-OWNER tx-sender)
(define-constant BURN-WALLET 'ST5EDWN88FN8Q6A1MQ0N7SKKAG0VZ0ZQ9MXZCEJK)
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-SALE-NOT-ACTIVE (err u101))
(define-constant ERR-NO-MINTPASS-REMAINING (err u102))
(define-constant ERR-NOT-OWNER (err u103))

;; Variables
(define-data-var mintpass-sale-active bool false)
(define-data-var sale-active bool false)

;; Get presale balance
(define-read-only (get-presale-balance (account principal))
  (default-to u0
    (map-get? presale-count account)))

;; Check mintpass sales active
(define-read-only (mintpass-enabled)
  (ok (var-get mintpass-sale-active)))

;; Check public sales active
(define-read-only (public-enabled)
  (ok (var-get sale-active)))

;; Set mintpass sale flag (only contract owner)
(define-public (flip-mintpass-sale)
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER)  ERR-NOT-AUTHORIZED)
    (var-set sale-active false)
    (var-set mintpass-sale-active (not (var-get mintpass-sale-active)))
    (ok (var-get mintpass-sale-active))))

;; Set public sale flag (only contract owner)
(define-public (flip-sale)
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (var-set mintpass-sale-active false)
    (var-set sale-active (not (var-get sale-active)))
    (ok (var-get sale-active))))

;; Claim NFT
(define-public (claim)
  (if (var-get mintpass-sale-active)
    (mintpass-mint tx-sender)
    (public-mint tx-sender)))

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

;; Claim 20 NFT
(define-public (claim-twenty)
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

;; Burn 5 NFTs / Phase 3
(define-public (burn-phase-3 (id1 uint) (id2 uint) (id3 uint) (id4 uint) (id5 uint))
  (begin
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase3-t0 get-owner id1) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase3-t0 get-owner id2) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase3-t0 get-owner id3) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase3-t0 get-owner id4) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase3-t0 get-owner id5) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (try! (contract-call? .phase3-t0 transfer id1 tx-sender BURN-WALLET))
      (try! (contract-call? .phase3-t0 transfer id2 tx-sender BURN-WALLET))
      (try! (contract-call? .phase3-t0 transfer id3 tx-sender BURN-WALLET))
      (try! (contract-call? .phase3-t0 transfer id4 tx-sender BURN-WALLET))
      (try! (contract-call? .phase3-t0 transfer id5 tx-sender BURN-WALLET))
      (try! (contract-call? .phase4-t0 mint tx-sender))
      (ok true)))

;; Burn 5 NFTs / Phase 
(define-public (burn-phase-4 (id uint))
  (begin
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase4-t0 get-owner id) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (try! (contract-call? .phase4-t0 transfer id tx-sender BURN-WALLET))
      (try! (contract-call? .token mint u100000000 tx-sender))
      (ok true)))

;; Internal - Mint NFT using Mintpass
(define-private (mintpass-mint (new-owner principal))
  (let ((presale-balance (get-presale-balance new-owner)))
    (asserts! (> presale-balance u0) ERR-NO-MINTPASS-REMAINING)
    (map-set presale-count
              new-owner
              (- presale-balance u1))
  (try! (contract-call? .phase1-t0 mint new-owner))
  (ok true)))

;; Internal - Mint NFT via public sale
(define-private (public-mint (new-owner principal))
  (begin
    (asserts! (var-get sale-active) ERR-SALE-NOT-ACTIVE)
    (try! (contract-call? .phase1-t0 mint new-owner))
    (ok true)))

;; Register this contract as allowed to mint
(as-contract (contract-call? .phase1-t0 set-mint-address))
(as-contract (contract-call? .phase2-t0 set-mint-address))
(as-contract (contract-call? .phase3-t0 set-mint-address))
(as-contract (contract-call? .phase4-t0 set-mint-address))
(as-contract (contract-call? .token set-mint-address))

;; Mintpasses
(map-set presale-count 'STVB6RR16PBSE76N2PN7SRGDRYV7R10DTX7YH0E4 u50)
(map-set presale-count 'ST2A3AFH1K78QH13AM2ZDZ50YKHJFQSPT0F6YFE4F u50)