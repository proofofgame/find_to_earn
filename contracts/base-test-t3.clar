;; Skullcoin | Find to Earn | Beta Test #3 | v.0.3.0
;; skullco.in

;; Traits
(use-trait ft-trait 'ST3T54N6G4HN7GPBCYMSDKP4W00C45X19GNH7C0T6.sip-010-trait-ft-standard.sip-010-trait)

;; Constants and Errors
(define-constant CONTRACT-OWNER tx-sender)
(define-constant BURN-WALLET 'ST5EDWN88FN8Q6A1MQ0N7SKKAG0VZ0ZQ9MXZCEJK)
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-SALE-NOT-ACTIVE (err u101))
(define-constant ERR-NOT-OWNER (err u102))
(define-constant ERR-NOT-TREASURE (err u103))
(define-constant ERR-NOT-COINS (err u104))
(define-constant REACHED-BLOCK-PICK-LIMIT (err u105))

;; Variables
(define-data-var sale-active bool false)
(define-data-var factor uint u1)
(define-data-var last-block uint u0)
(define-data-var byte-id uint u0)
(define-data-var picked-id uint u0)
(define-data-var last-vrf (buff 64) 0x00)

;; Maps
(define-map treasure-phase-1 { id: uint} {claim: bool})
(define-map treasure-phase-2 { id: uint} {claim: bool})
(define-map treasure-phase-3 { id: uint} {claim: bool})
(define-map coins-phase-1 { id: uint} {claim: bool})
(define-map coins-phase-2 { id: uint} {claim: bool})
(define-map coins-phase-3 { id: uint} {claim: bool})

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

;; Deposit SIP-010 tokens in contract (only contract owner)
(define-public (deposit (asset <ft-trait>) (amount uint))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (try! (contract-call? asset transfer amount tx-sender (as-contract tx-sender) none))
  (ok true)))

;; Withdrawal SIP-010 tokens from contract (only contract owner)
(define-public (withdraw (asset <ft-trait>) (amount uint))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (try! (as-contract (contract-call? asset transfer amount tx-sender CONTRACT-OWNER none)))
  (ok true)))

;; Send SIP-010 tokens to player (only contract owner)
(define-public (send (asset <ft-trait>) (amount uint) (player principal))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (try! (as-contract (contract-call? asset transfer amount tx-sender player none)))
  (ok true)))

;; Deposit STX in contract (only contract owner)
(define-public (deposit-stx (amount uint))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))
  (ok true)))

;; Withdrawal STX from contract (only contract owner)
(define-public (withdraw-stx (amount uint))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (try! (as-contract (stx-transfer? amount tx-sender CONTRACT-OWNER)))
  (ok true)))

;; Send STX to player (only contract owner)
(define-public (send-stx (amount uint) (player principal))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (try! (as-contract (stx-transfer? amount tx-sender player)))
  (ok true)))

;; Set treasures ids / Phase 1 (only contract owner)
(define-public (set-treasure-phase-1 (nft-id uint) (status bool))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (map-set treasure-phase-1 { id: nft-id } { claim: status})
  (ok true)))

;; Set treasures ids / Phase 2 (only contract owner)
(define-public (set-treasure-phase-2 (nft-id uint) (status bool))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (map-set treasure-phase-2 { id: nft-id } { claim: status})
  (ok true)))

;; Set treasures ids / Phase 3 (only contract owner)
(define-public (set-treasure-phase-3 (nft-id uint) (status bool))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (map-set treasure-phase-3 { id: nft-id } { claim: status})
  (ok true)))

;; Set coins ids / Phase 1 (only contract owner)
(define-public (set-coins-phase-1 (nft-id uint) (status bool))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (map-set coins-phase-1 { id: nft-id } { claim: status})
  (ok true)))

;; Set coins ids / Phase 2 (only contract owner)
(define-public (set-coins-phase-2 (nft-id uint) (status bool))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (map-set coins-phase-2 { id: nft-id } { claim: status})
  (ok true)))

;; Set coins ids / Phase 3 (only contract owner)
(define-public (set-coins-phase-3 (nft-id uint) (status bool))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (map-set coins-phase-3 { id: nft-id } { claim: status})
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
(define-public (claim-treasure-phase-1 (id uint))
  (let ((fx (var-get factor)))
    (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase1-test-t3 get-owner id) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
    (try! (pick-id))
        (if (is-eq (mod (var-get picked-id) u2) u0)
          (begin
            (asserts! (is-eq (get claim (unwrap-panic (map-get? treasure-phase-1 { id: id }))) true) ERR-NOT-TREASURE)
            (try! (send-stx (* fx u1000000) tx-sender))
            (map-set treasure-phase-1 { id: id } { claim: false})
            (print "Congrats")
            (ok (var-get picked-id)))
          (begin
            (print "Not this time")
            (ok (var-get picked-id))))))

;; Claim treasure / Phase 2
(define-public (claim-treasure-phase-2 (id uint))
  (let ((fx (var-get factor)))
    (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase2-test-t3 get-owner id) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
    (try! (pick-id))
        (if (is-eq (mod (var-get picked-id) u2) u0)
          (begin
            (asserts! (is-eq (get claim (unwrap-panic (map-get? treasure-phase-2 { id: id }))) true) ERR-NOT-TREASURE)
            (try! (send-stx (* fx u1000000) tx-sender))
            (map-set treasure-phase-2 { id: id } { claim: false})
            (print "Congrats")
            (ok (var-get picked-id)))
          (begin
            (print "Not this time")
            (ok (var-get picked-id))))))

;; Claim treasure / Phase 3
(define-public (claim-treasure-phase-3 (id uint))
  (let ((fx (var-get factor)))
    (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase3-test-t3 get-owner id) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
    (try! (pick-id))
        (if (is-eq (mod (var-get picked-id) u2) u0)
          (begin
            (asserts! (is-eq (get claim (unwrap-panic (map-get? treasure-phase-3 { id: id }))) true) ERR-NOT-TREASURE)
            (try! (send-stx (* fx u1000000) tx-sender))
            (map-set treasure-phase-3 { id: id } { claim: false})
            (print "Congrats")
            (ok (var-get picked-id)))
          (begin
            (print "Not this time")
            (ok (var-get picked-id))))))

;; Claim coins / Phase 1
(define-public (claim-coins-phase-1 (id uint))
  (let ((fx (var-get factor)))
    (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase1-test-t3 get-owner id) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
    (try! (pick-id))
        (if (is-eq (mod (var-get picked-id) u2) u0)
          (begin
            (asserts! (is-eq (get claim (unwrap-panic (map-get? coins-phase-1 { id: id }))) true) ERR-NOT-COINS)
            (try! (send-stx (* fx u500000) tx-sender))
            (map-set coins-phase-1 { id: id } { claim: false})
            (print "Congrats")
            (ok (var-get picked-id)))
          (begin
            (print "Not this time")
            (ok (var-get picked-id))))))

;; Claim coins / Phase 2
(define-public (claim-coins-phase-2 (id uint))
  (let ((fx (var-get factor)))
    (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase2-test-t3 get-owner id) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
    (try! (pick-id))
        (if (is-eq (mod (var-get picked-id) u2) u0)
          (begin
            (asserts! (is-eq (get claim (unwrap-panic (map-get? coins-phase-2 { id: id }))) true) ERR-NOT-COINS)
            (try! (send-stx (* fx u500000) tx-sender))
            (map-set coins-phase-2 { id: id } { claim: false})
            (print "Congrats")
            (ok (var-get picked-id)))
          (begin
            (print "Not this time")
            (ok (var-get picked-id))))))

;; Claim coins / Phase 3
(define-public (claim-coins-phase-3 (id uint))
  (let ((fx (var-get factor)))
    (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase3-test-t3 get-owner id) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
    (try! (pick-id))
        (if (is-eq (mod (var-get picked-id) u2) u0)
          (begin
            (asserts! (is-eq (get claim (unwrap-panic (map-get? coins-phase-3 { id: id }))) true) ERR-NOT-COINS)
            (try! (send-stx (* fx u500000) tx-sender))
            (map-set coins-phase-3 { id: id } { claim: false})
            (print "Congrats")
            (ok (var-get picked-id)))
          (begin
            (print "Not this time")
            (ok (var-get picked-id))))))

;; Burn 5 NFTs / Phase 1
(define-public (burn-phase-1 (id1 uint) (id2 uint) (id3 uint) (id4 uint) (id5 uint))
  (begin
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase1-test-t3 get-owner id1) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase1-test-t3 get-owner id2) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase1-test-t3 get-owner id3) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase1-test-t3 get-owner id4) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase1-test-t3 get-owner id5) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (try! (contract-call? .phase1-test-t3 transfer id1 tx-sender BURN-WALLET))
      (try! (contract-call? .phase1-test-t3 transfer id2 tx-sender BURN-WALLET))
      (try! (contract-call? .phase1-test-t3 transfer id3 tx-sender BURN-WALLET))
      (try! (contract-call? .phase1-test-t3 transfer id4 tx-sender BURN-WALLET))
      (try! (contract-call? .phase1-test-t3 transfer id5 tx-sender BURN-WALLET))
      (try! (contract-call? .phase2-test-t3 mint tx-sender))
      (try! (contract-call? .phase2-test-t3 mint tx-sender))
      (ok true)))

;; Burn 5 NFTs / Phase 2
(define-public (burn-phase-2 (id1 uint) (id2 uint) (id3 uint) (id4 uint) (id5 uint))
  (begin
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase2-test-t3 get-owner id1) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase2-test-t3 get-owner id2) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase2-test-t3 get-owner id3) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase2-test-t3 get-owner id4) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase2-test-t3 get-owner id5) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (try! (contract-call? .phase2-test-t3 transfer id1 tx-sender BURN-WALLET))
      (try! (contract-call? .phase2-test-t3 transfer id2 tx-sender BURN-WALLET))
      (try! (contract-call? .phase2-test-t3 transfer id3 tx-sender BURN-WALLET))
      (try! (contract-call? .phase2-test-t3 transfer id4 tx-sender BURN-WALLET))
      (try! (contract-call? .phase2-test-t3 transfer id5 tx-sender BURN-WALLET))
      (try! (contract-call? .phase3-test-t3 mint tx-sender))
      (try! (contract-call? .phase3-test-t3 mint tx-sender))
      (ok true)))

;; Burn 5 NFTs / Phase 3
(define-public (burn-phase-3 (id1 uint) (id2 uint) (id3 uint) (id4 uint) (id5 uint))
  (begin
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase3-test-t3 get-owner id1) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase3-test-t3 get-owner id2) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase3-test-t3 get-owner id3) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase3-test-t3 get-owner id4) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (asserts! (is-eq (unwrap! (unwrap! (contract-call? .phase3-test-t3 get-owner id5) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
      (try! (contract-call? .phase3-test-t3 transfer id1 tx-sender BURN-WALLET))
      (try! (contract-call? .phase3-test-t3 transfer id2 tx-sender BURN-WALLET))
      (try! (contract-call? .phase3-test-t3 transfer id3 tx-sender BURN-WALLET))
      (try! (contract-call? .phase3-test-t3 transfer id4 tx-sender BURN-WALLET))
      (try! (contract-call? .phase3-test-t3 transfer id5 tx-sender BURN-WALLET))
      (try! (contract-call? .phase4-test-t3 mint tx-sender))
      (ok true)))

;; Claim NFT
(define-private (claim)
  (begin
    (mint tx-sender)))

;; Internal - Mint NFT
(define-private (mint (new-owner principal))
  (begin
    (asserts! (var-get sale-active) ERR-SALE-NOT-ACTIVE)
    (try! (contract-call? .phase1-test-t3 mint new-owner))
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
(as-contract (contract-call? .phase1-test-t3 set-mint-address))
(as-contract (contract-call? .phase2-test-t3 set-mint-address))
(as-contract (contract-call? .phase3-test-t3 set-mint-address))
(as-contract (contract-call? .phase4-test-t3 set-mint-address))