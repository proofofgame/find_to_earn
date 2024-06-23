;; Constants and Errors
(define-constant CONTRACT-OWNER tx-sender)
(define-constant BURN-WALLET 'ST5EDWN88FN8Q6A1MQ0N7SKKAG0VZ0ZQ9MXZCEJK)
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-SALE-NOT-ACTIVE (err u101))
(define-constant ERR-NOT-OWNER (err u102))
(define-constant ERR-NOT-TREASURE (err u103))
(define-constant REACHED-BLOCK-PICK-LIMIT (err u104))

;; Variables
(define-data-var sale-active bool false)
(define-data-var factor uint u1)
(define-data-var last-block uint u0)
(define-data-var byte-id uint u0)
(define-data-var picked-id uint u0)
(define-data-var last-vrf (buff 64) 0x000102030405)

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
    (try! (contract-call? .token-test-t1 mint some-value tx-sender))
    (try! (contract-call? .token-test-t1 burn some-value tx-sender))
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

;; Claim treasure / Phase 1
;; Add a restriction - pick up the treasure once
(define-public (claim-treasure-phase-1 (id uint))
  (let ((fx (var-get factor)))
    (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase1-test-t1 get-owner id) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
    (asserts! (is-eq (mod id u5) u0) ERR-NOT-TREASURE)
    (try! (pick-id))
        (if (is-eq (mod (var-get picked-id) u2) u0)
          (begin
            (try! (contract-call? .token-test-t1 mint (* fx u1000000) tx-sender))
            (print "Congrats")
            (ok (var-get picked-id)))
          (begin
            (print "Not this time")
            (ok (var-get picked-id))))))

;; Claim treasure / Phase 2
(define-public (claim-treasure-phase-2 (id uint))
  (let ((fx (var-get factor)))
    (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase2-test-t1 get-owner id) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
    (asserts! (is-eq (mod id u5) u0) ERR-NOT-TREASURE)
    (try! (pick-id))
        (if (is-eq (mod (var-get picked-id) u2) u0)
          (begin
            (try! (contract-call? .token-test-t1 mint (* fx u2000000) tx-sender))
            (print "Congrats")
            (ok (var-get picked-id)))
          (begin
            (print "Not this time")
            (ok (var-get picked-id))))))

;; Claim treasure / Phase 3
(define-public (claim-treasure-phase-3 (id uint))
  (let ((fx (var-get factor)))
    (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase3-test-t1 get-owner id) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
    (asserts! (is-eq (mod id u5) u0) ERR-NOT-TREASURE)
    (try! (pick-id))
        (if (is-eq (mod (var-get picked-id) u2) u0)
          (begin
            (try! (contract-call? .token-test-t1 mint (* fx u3000000) tx-sender))
            (print "Congrats")
            (ok (var-get picked-id)))
          (begin
            (print "Not this time")
            (ok (var-get picked-id))))))

;; Claim treasure / Phase 4
(define-public (claim-treasure-phase-4 (id uint))
  (let ((fx (var-get factor)))
    (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase4-test-t1 get-owner id) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
    (asserts! (is-eq (mod id u5) u0) ERR-NOT-TREASURE)
    (try! (pick-id))
        (if (is-eq (mod (var-get picked-id) u2) u0)
          (begin
            (try! (contract-call? .token-test-t1 mint (* fx u4000000) tx-sender))
            (print "Congrats")
            (ok (var-get picked-id)))
          (begin
            (print "Not this time")
            (ok (var-get picked-id))))))

;; Claim treasure / Phase 5
(define-public (claim-treasure-phase-5 (id uint))
  (let ((fx (var-get factor)))
    (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase5-test-t1 get-owner id) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
    (asserts! (is-eq (mod id u5) u0) ERR-NOT-TREASURE)
    (try! (pick-id))
        (if (is-eq (mod (var-get picked-id) u2) u0)
          (begin
            (try! (contract-call? .token-test-t1 mint (* fx u5000000) tx-sender))
            (print "Congrats")
            (ok (var-get picked-id)))
          (begin
            (print "Not this time")
            (ok (var-get picked-id))))))

;; Claim treasure / Phase 6
(define-public (claim-treasure-phase-6 (id uint))
  (let ((fx (var-get factor)))
    (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase6-test-t1 get-owner id) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
    (asserts! (is-eq (mod id u5) u0) ERR-NOT-TREASURE)
    (try! (pick-id))
        (if (is-eq (mod (var-get picked-id) u2) u0)
          (begin
            (try! (contract-call? .token-test-t1 mint (* fx u10000000) tx-sender))
            (print "Congrats")
            (ok (var-get picked-id)))
          (begin
            (print "Not this time")
            (ok (var-get picked-id))))))

;; Burn 5 NFTs / Phase 1
(define-public (burn-phase-1 (id1 uint) (id2 uint) (id3 uint) (id4 uint) (id5 uint))
  (begin
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase1-test-t1 get-owner id1) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase1-test-t1 get-owner id2) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase1-test-t1 get-owner id3) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase1-test-t1 get-owner id4) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase1-test-t1 get-owner id5) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (try! (contract-call? .phase1-test-t1 transfer id1 tx-sender BURN-WALLET))
      (try! (contract-call? .phase1-test-t1 transfer id2 tx-sender BURN-WALLET))
      (try! (contract-call? .phase1-test-t1 transfer id3 tx-sender BURN-WALLET))
      (try! (contract-call? .phase1-test-t1 transfer id4 tx-sender BURN-WALLET))
      (try! (contract-call? .phase1-test-t1 transfer id5 tx-sender BURN-WALLET))
      (try! (contract-call? .phase2-test-t1 mint tx-sender))
      (try! (contract-call? .phase2-test-t1 mint tx-sender))
      (try! (contract-call? .phase2-test-t1 mint tx-sender))
      (try! (contract-call? .phase2-test-t1 mint tx-sender))
      (try! (contract-call? .phase2-test-t1 mint tx-sender))
      (ok true)))

;; Burn 5 NFTs / Phase 2
(define-public (burn-phase-2 (id1 uint) (id2 uint) (id3 uint) (id4 uint) (id5 uint))
  (begin
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase2-test-t1 get-owner id1) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase2-test-t1 get-owner id2) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase2-test-t1 get-owner id3) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase2-test-t1 get-owner id4) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase2-test-t1 get-owner id5) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (try! (contract-call? .phase2-test-t1 transfer id1 tx-sender BURN-WALLET))
      (try! (contract-call? .phase2-test-t1 transfer id2 tx-sender BURN-WALLET))
      (try! (contract-call? .phase2-test-t1 transfer id3 tx-sender BURN-WALLET))
      (try! (contract-call? .phase2-test-t1 transfer id4 tx-sender BURN-WALLET))
      (try! (contract-call? .phase2-test-t1 transfer id5 tx-sender BURN-WALLET))
      (try! (contract-call? .phase3-test-t1 mint tx-sender))
      (try! (contract-call? .phase3-test-t1 mint tx-sender))
      (try! (contract-call? .phase3-test-t1 mint tx-sender))
      (try! (contract-call? .phase3-test-t1 mint tx-sender))
      (try! (contract-call? .phase3-test-t1 mint tx-sender))
      (ok true)))

;; Burn 5 NFTs / Phase 3
(define-public (burn-phase-3 (id1 uint) (id2 uint) (id3 uint) (id4 uint) (id5 uint))
  (begin
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase3-test-t1 get-owner id1) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase3-test-t1 get-owner id2) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase3-test-t1 get-owner id3) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase3-test-t1 get-owner id4) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase3-test-t1 get-owner id5) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (try! (contract-call? .phase3-test-t1 transfer id1 tx-sender BURN-WALLET))
      (try! (contract-call? .phase3-test-t1 transfer id2 tx-sender BURN-WALLET))
      (try! (contract-call? .phase3-test-t1 transfer id3 tx-sender BURN-WALLET))
      (try! (contract-call? .phase3-test-t1 transfer id4 tx-sender BURN-WALLET))
      (try! (contract-call? .phase3-test-t1 transfer id5 tx-sender BURN-WALLET))
      (try! (contract-call? .phase4-test-t1 mint tx-sender))
      (try! (contract-call? .phase4-test-t1 mint tx-sender))
      (try! (contract-call? .phase4-test-t1 mint tx-sender))
      (try! (contract-call? .phase4-test-t1 mint tx-sender))
      (try! (contract-call? .phase4-test-t1 mint tx-sender))
      (ok true)))

;; Burn 5 NFTs / Phase 4
(define-public (burn-phase-4 (id1 uint) (id2 uint) (id3 uint) (id4 uint) (id5 uint))
  (begin
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase4-test-t1 get-owner id1) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase4-test-t1 get-owner id2) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase4-test-t1 get-owner id3) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase4-test-t1 get-owner id4) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase4-test-t1 get-owner id5) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (try! (contract-call? .phase4-test-t1 transfer id1 tx-sender BURN-WALLET))
      (try! (contract-call? .phase4-test-t1 transfer id2 tx-sender BURN-WALLET))
      (try! (contract-call? .phase4-test-t1 transfer id3 tx-sender BURN-WALLET))
      (try! (contract-call? .phase4-test-t1 transfer id4 tx-sender BURN-WALLET))
      (try! (contract-call? .phase4-test-t1 transfer id5 tx-sender BURN-WALLET))
      (try! (contract-call? .phase5-test-t1 mint tx-sender))
      (try! (contract-call? .phase5-test-t1 mint tx-sender))
      (try! (contract-call? .phase5-test-t1 mint tx-sender))
      (try! (contract-call? .phase5-test-t1 mint tx-sender))
      (try! (contract-call? .phase5-test-t1 mint tx-sender))
      (ok true)))

;; Burn 5 NFTs / Phase 5
(define-public (burn-phase-5 (id1 uint) (id2 uint) (id3 uint) (id4 uint) (id5 uint))
  (begin
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase5-test-t1 get-owner id1) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase5-test-t1 get-owner id2) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase5-test-t1 get-owner id3) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase5-test-t1 get-owner id4) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase5-test-t1 get-owner id5) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (try! (contract-call? .phase5-test-t1 transfer id1 tx-sender BURN-WALLET))
      (try! (contract-call? .phase5-test-t1 transfer id2 tx-sender BURN-WALLET))
      (try! (contract-call? .phase5-test-t1 transfer id3 tx-sender BURN-WALLET))
      (try! (contract-call? .phase5-test-t1 transfer id4 tx-sender BURN-WALLET))
      (try! (contract-call? .phase5-test-t1 transfer id5 tx-sender BURN-WALLET))
      (try! (contract-call? .phase6-test-t1 mint tx-sender))
      (try! (contract-call? .phase6-test-t1 mint tx-sender))
      (try! (contract-call? .phase6-test-t1 mint tx-sender))
      (try! (contract-call? .phase6-test-t1 mint tx-sender))
      (try! (contract-call? .phase6-test-t1 mint tx-sender))
      (ok true)))

;; Burn 5 NFTs / Phase 6
(define-public (burn-phase-6 (id1 uint) (id2 uint) (id3 uint) (id4 uint) (id5 uint))
  (begin
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase6-test-t1 get-owner id1) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase6-test-t1 get-owner id2) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase6-test-t1 get-owner id3) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase6-test-t1 get-owner id4) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase6-test-t1 get-owner id5) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (try! (contract-call? .phase6-test-t1 transfer id1 tx-sender BURN-WALLET))
      (try! (contract-call? .phase6-test-t1 transfer id2 tx-sender BURN-WALLET))
      (try! (contract-call? .phase6-test-t1 transfer id3 tx-sender BURN-WALLET))
      (try! (contract-call? .phase6-test-t1 transfer id4 tx-sender BURN-WALLET))
      (try! (contract-call? .phase6-test-t1 transfer id5 tx-sender BURN-WALLET))
      (ok true)))

;; Claim NFT
(define-private (claim)
  (begin
    (mint tx-sender)))

;; Internal - Mint NFT
(define-private (mint (new-owner principal))
  (begin
    (asserts! (var-get sale-active) ERR-SALE-NOT-ACTIVE)
    (try! (contract-call? .phase1-test-t1 mint new-owner))
    (ok true)))

;; Pick id with RNG based on VRF
(define-private (pick-id)
  (let ((vrf (var-get last-vrf))
        (b-idx (var-get byte-id)))
    (if (is-eq (var-get last-block) block-height)
      (begin
        (asserts! (< b-idx u63) REACHED-BLOCK-PICK-LIMIT)
        (var-set picked-id (buff-to-uint-be (unwrap-panic (element-at vrf b-idx))))
        (var-set byte-id (+ b-idx u1))
        (ok (var-get picked-id)))
      (begin
        (set-vrf)
        (var-set last-block block-height)
        (var-set picked-id (buff-to-uint-be (unwrap-panic (element-at vrf b-idx))))
        (var-set byte-id u1)
        (ok (var-get picked-id))))))

;; Set VRF from previous block
(define-private (set-vrf)    
    (var-set last-vrf (sha512 (unwrap-panic (get-block-info? vrf-seed (- block-height u1))))))

;; Register this contract as allowed to mint
(as-contract (contract-call? .phase1-test-t1 set-mint-address))
(as-contract (contract-call? .phase2-test-t1 set-mint-address))
(as-contract (contract-call? .phase3-test-t1 set-mint-address))
(as-contract (contract-call? .phase4-test-t1 set-mint-address))
(as-contract (contract-call? .phase5-test-t1 set-mint-address))
(as-contract (contract-call? .phase6-test-t1 set-mint-address))
(as-contract (contract-call? .token-test-t1 set-mint-address))