;; Skullcoin | Competitive | Buidl Battle | v.1.0.1
;; skullco.in

;; Traits
(use-trait ft-trait 'ST3T54N6G4HN7GPBCYMSDKP4W00C45X19GNH7C0T6.sip-010-trait.sip-010-trait)

;; Constants and Errors
(define-constant CONTRACT-OWNER tx-sender)
(define-constant BURN-WALLET 'ST5EDWN88FN8Q6A1MQ0N7SKKAG0VZ0ZQ9MXZCEJK)
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-SALE-NOT-ACTIVE (err u101))
(define-constant ERR-NOT-OWNER (err u102))
(define-constant ERR-NOT-TREASURE-OR-CLAIMED (err u103))
(define-constant ERR-NOT-CHEST-OR-CLAIMED (err u104))
(define-constant ERR-NOT-TOKENS-OR-CLAIMED (err u105))
(define-constant ERR-NOT-STX-OR-CLAIMED (err u106))
(define-constant REACHED-BLOCK-PICK-LIMIT (err u107))
(define-constant ERR-NO-WL-REMAINING (err u108))

;; Variables
(define-data-var wl-sale-active bool false)
(define-data-var sale-active bool false)
(define-data-var last-block uint u0)
(define-data-var byte-id uint u0)
(define-data-var picked-id uint u0)
(define-data-var last-vrf (buff 64) 0x00)

;; Maps
(define-map wl-count principal uint)
(define-map treasure-phase-1 { id: uint} {claim: bool})
(define-map treasure-phase-2 { id: uint} {claim: bool})
(define-map treasure-phase-3 { id: uint} {claim: bool})
(define-map chest-phase-1 { id: uint} {claim: bool})
(define-map chest-phase-2 { id: uint} {claim: bool})
(define-map chest-phase-3 { id: uint} {claim: bool})
(define-map tokens-phase-1 { id: uint} {claim: bool})
(define-map tokens-phase-2 { id: uint} {claim: bool})
(define-map tokens-phase-3 { id: uint} {claim: bool})
(define-map stx-phase-1 { id: uint} {claim: bool})
(define-map stx-phase-2 { id: uint} {claim: bool})
(define-map stx-phase-3 { id: uint} {claim: bool})
(define-map awards { phase: uint, id: uint } { type: (string-ascii 10), claim: bool })

;; Get whitelist balance
(define-read-only (get-wl-balance (account principal))
  (default-to u0
    (map-get? wl-count account)))

;; Get award claim status
(define-read-only (get-award-status (phase-id uint) (nft-id uint))
    (ok (map-get? awards (tuple (phase phase-id) (id nft-id))))
)

;; Check whitelist sales active
(define-read-only (wl-enabled)
  (ok (var-get wl-sale-active)))

;; Check public sales active
(define-read-only (public-enabled)
  (ok (var-get sale-active)))

;; Set whitelist sale flag (only contract owner)
(define-public (flip-wl-sale)
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (var-set wl-sale-active (not (var-get wl-sale-active)))
  (ok (var-get wl-sale-active))))

;; Set public sale flag (only contract owner)
(define-public (flip-sale)
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (var-set sale-active (not (var-get sale-active)))
    (ok (var-get sale-active))))

;; Deposit SIP-010 tokens in contract (only contract owner)
(define-public (deposit-ft (asset <ft-trait>) (amount uint))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (try! (contract-call? asset transfer amount tx-sender (as-contract tx-sender) none))
  (ok true)))

;; Withdrawal SIP-010 tokens from contract (only contract owner)
(define-public (withdraw-ft (asset <ft-trait>) (amount uint))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (try! (as-contract (contract-call? asset transfer amount tx-sender CONTRACT-OWNER none)))
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

;; Set whitelist wallets (only contract owner)
(define-public (set-wl-wallets (wallet principal) (amount uint))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (map-set wl-count wallet amount)
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

;; Set chests ids / Phase 1 (only contract owner)
(define-public (set-chest-phase-1 (nft-id uint) (status bool))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (map-set chest-phase-1 { id: nft-id } { claim: status})
  (ok true)))

;; Set chests ids / Phase 2 (only contract owner)
(define-public (set-chest-phase-2 (nft-id uint) (status bool))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (map-set chest-phase-2 { id: nft-id } { claim: status})
  (ok true)))

;; Set chests ids / Phase 3 (only contract owner)
(define-public (set-chest-phase-3 (nft-id uint) (status bool))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (map-set chest-phase-3 { id: nft-id } { claim: status})
  (ok true)))

;; Set tokens ids / Phase 1 (only contract owner)
(define-public (set-tokens-phase-1 (nft-id uint) (status bool))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (map-set tokens-phase-1 { id: nft-id } { claim: status})
  (ok true)))

;; Set tokens ids / Phase 2 (only contract owner)
(define-public (set-tokens-phase-2 (nft-id uint) (status bool))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (map-set tokens-phase-2 { id: nft-id } { claim: status})
  (ok true)))

;; Set tokens ids / Phase 3 (only contract owner)
(define-public (set-tokens-phase-3 (nft-id uint) (status bool))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (map-set tokens-phase-3 { id: nft-id } { claim: status})
  (ok true)))

;; Set stx reward ids / Phase 1 (only contract owner)
(define-public (set-stx-phase-1 (nft-id uint) (status bool))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (map-set stx-phase-1 { id: nft-id } { claim: status})
  (ok true)))

;; Set stx reward ids / Phase 2 (only contract owner)
(define-public (set-stx-phase-2 (nft-id uint) (status bool))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (map-set stx-phase-2 { id: nft-id } { claim: status})
  (ok true)))

;; Set stx reward ids / Phase 3 (only contract owner)
(define-public (set-stx-phase-3 (nft-id uint) (status bool))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (map-set stx-phase-3 { id: nft-id } { claim: status})
  (ok true)))

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

;; Claim treasure / Phase 1
(define-public (claim-treasure-phase-1 (id uint) (amount uint))
  (begin
    (asserts! (is-eq (unwrap! (unwrap! (contract-call? .skullcoin-competitive-bb-phase1 get-owner id) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
    (asserts! (is-eq (get claim (unwrap-panic (map-get? treasure-phase-1 { id: id }))) true) ERR-NOT-TREASURE-OR-CLAIMED)
    (try! (send-stx-to-winner amount tx-sender))
    (map-set treasure-phase-1 { id: id } { claim: false})
    (map-set awards { phase: u1, id: id } { type: "treasure" , claim: false })
    (print {
      result: "congrats",
      asset: "stx",
      amount: amount,
      nft-id: id,
      user: contract-caller
    })
  (ok true)))

;; Claim treasure / Phase 2
(define-public (claim-treasure-phase-2 (id uint) (amount uint))
  (begin
    (asserts! (is-eq (unwrap! (unwrap! (contract-call? .skullcoin-competitive-bb-phase2 get-owner id) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
    (asserts! (is-eq (get claim (unwrap-panic (map-get? treasure-phase-2 { id: id }))) true) ERR-NOT-TREASURE-OR-CLAIMED)
    (try! (send-stx-to-winner amount tx-sender))
    (map-set treasure-phase-2 { id: id } { claim: false})
    (map-set awards { phase: u2, id: id } { type: "treasure" , claim: false })
    (print {
      result: "congrats",
      asset: "stx",
      amount: amount,
      nft-id: id,
      user: contract-caller
    })
  (ok true)))

;; Claim treasure / Phase 3
(define-public (claim-treasure-phase-3 (id uint) (amount uint))
  (begin
    (asserts! (is-eq (unwrap! (unwrap! (contract-call? .skullcoin-competitive-bb-phase3 get-owner id) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
    (asserts! (is-eq (get claim (unwrap-panic (map-get? treasure-phase-3 { id: id }))) true) ERR-NOT-TREASURE-OR-CLAIMED)
    (try! (send-stx-to-winner amount tx-sender))
    (map-set treasure-phase-3 { id: id } { claim: false})
    (map-set awards { phase: u3, id: id } { type: "treasure" , claim: false })
    (print {
      result: "congrats",
      asset: "stx",
      amount: amount,
      nft-id: id,
      user: contract-caller
    })
  (ok true)))

;; Claim chest / Phase 1
(define-public (claim-chest-phase-1 (id uint) (amount uint))
  (begin
    (asserts! (is-eq (unwrap! (unwrap! (contract-call? .skullcoin-competitive-bb-phase1 get-owner id) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
    (asserts! (is-eq (get claim (unwrap-panic (map-get? chest-phase-1 { id: id }))) true) ERR-NOT-CHEST-OR-CLAIMED)
    (try! (pick-id))
        (if (is-eq (mod (var-get picked-id) u2) u0)
          (begin
            (try! (send-stx-to-winner amount tx-sender))
            (map-set chest-phase-1 { id: id } { claim: false})
            (map-set awards { phase: u1, id: id } { type: "chest" , claim: false })
            (print {
              result: "congrats",
              asset: "stx",
              amount: amount,
              nft-id: id,
              user: contract-caller
            })
          (ok (var-get picked-id)))
          (begin
            (map-set chest-phase-1 { id: id } { claim: false})
            (map-set awards { phase: u1, id: id } { type: "chest" , claim: false })
            (print {
              result: "not this time",
              asset: "stx",
              amount: amount,
              nft-id: id,
              user: contract-caller
            })
          (ok (var-get picked-id))))))

;; Claim chest / Phase 2
(define-public (claim-chest-phase-2 (id uint) (amount uint))
  (begin
    (asserts! (is-eq (unwrap! (unwrap! (contract-call? .skullcoin-competitive-bb-phase2 get-owner id) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
    (asserts! (is-eq (get claim (unwrap-panic (map-get? chest-phase-2 { id: id }))) true) ERR-NOT-CHEST-OR-CLAIMED)
    (try! (pick-id))
        (if (is-eq (mod (var-get picked-id) u2) u0)
          (begin
            (try! (send-stx-to-winner amount tx-sender))
            (map-set chest-phase-2 { id: id } { claim: false})
            (map-set awards { phase: u2, id: id } { type: "chest" , claim: false })
            (print {
              result: "congrats",
              asset: "stx",
              amount: amount,
              nft-id: id,
              user: contract-caller
            })
          (ok (var-get picked-id)))
          (begin
            (map-set chest-phase-2 { id: id } { claim: false})
            (map-set awards { phase: u2, id: id } { type: "chest" , claim: false })
            (print {
              result: "not this time",
              asset: "stx",
              amount: amount,
              nft-id: id,
              user: contract-caller
            })
          (ok (var-get picked-id))))))

;; Claim chest / Phase 3
(define-public (claim-chest-phase-3 (id uint) (amount uint))
  (begin
    (asserts! (is-eq (unwrap! (unwrap! (contract-call? .skullcoin-competitive-bb-phase3 get-owner id) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
    (asserts! (is-eq (get claim (unwrap-panic (map-get? chest-phase-3 { id: id }))) true) ERR-NOT-CHEST-OR-CLAIMED)
    (try! (pick-id))
        (if (is-eq (mod (var-get picked-id) u2) u0)
          (begin
            (try! (send-stx-to-winner amount tx-sender))
            (map-set chest-phase-3 { id: id } { claim: false})
            (map-set awards { phase: u3, id: id } { type: "chest" , claim: false })
            (print {
              result: "congrats",
              asset: "stx",
              amount: amount,
              nft-id: id,
              user: contract-caller
            })
          (ok (var-get picked-id)))
          (begin
            (map-set chest-phase-3 { id: id } { claim: false})
            (map-set awards { phase: u3, id: id } { type: "chest" , claim: false })
            (print {
              result: "not this time",
              asset: "stx",
              amount: amount,
              nft-id: id,
              user: contract-caller
            })
          (ok (var-get picked-id))))))

;; Claim STX / Phase 1
(define-public (claim-stx-phase-1 (id uint) (amount uint))
  (begin
    (asserts! (is-eq (unwrap! (unwrap! (contract-call? .skullcoin-competitive-bb-phase1 get-owner id) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
    (asserts! (is-eq (get claim (unwrap-panic (map-get? stx-phase-1 { id: id }))) true) ERR-NOT-STX-OR-CLAIMED)
    (try! (send-stx-to-winner amount tx-sender))
    (map-set stx-phase-1 { id: id } { claim: false})
    (map-set awards { phase: u1, id: id } { type: "stx" , claim: false })
    (print {
      result: "congrats",
      asset: "stx",
      amount: amount,
      nft-id: id,
      user: contract-caller
    })
  (ok true)))

;; Claim STX / Phase 2
(define-public (claim-stx-phase-2 (id uint) (amount uint))
  (begin
    (asserts! (is-eq (unwrap! (unwrap! (contract-call? .skullcoin-competitive-bb-phase2 get-owner id) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
    (asserts! (is-eq (get claim (unwrap-panic (map-get? stx-phase-2 { id: id }))) true) ERR-NOT-STX-OR-CLAIMED)
    (try! (send-stx-to-winner amount tx-sender))
    (map-set stx-phase-2 { id: id } { claim: false})
    (map-set awards { phase: u2, id: id } { type: "stx" , claim: false })
    (print {
      result: "congrats",
      asset: "stx",
      amount: amount,
      nft-id: id,
      user: contract-caller
    })
  (ok true)))

;; Claim STX / Phase 3
(define-public (claim-stx-phase-3 (id uint) (amount uint))
  (begin
    (asserts! (is-eq (unwrap! (unwrap! (contract-call? .skullcoin-competitive-bb-phase3 get-owner id) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
    (asserts! (is-eq (get claim (unwrap-panic (map-get? stx-phase-3 { id: id }))) true) ERR-NOT-STX-OR-CLAIMED)
    (try! (send-stx-to-winner amount tx-sender))
    (map-set stx-phase-3 { id: id } { claim: false})
    (map-set awards { phase: u3, id: id } { type: "stx" , claim: false })
    (print {
      result: "congrats",
      asset: "stx",
      amount: amount,
      nft-id: id,
      user: contract-caller
    })
  (ok true)))

;; Claim FT / Phase 1
(define-public (claim-tokens-phase-1 (asset <ft-trait>) (id uint) (amount uint))
  (begin
    (asserts! (is-eq (unwrap! (unwrap! (contract-call? .skullcoin-competitive-bb-phase1 get-owner id) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
    (asserts! (is-eq (get claim (unwrap-panic (map-get? tokens-phase-1 { id: id }))) true) ERR-NOT-TOKENS-OR-CLAIMED)
    (try! (send-ft-to-winner asset amount tx-sender))
    (map-set tokens-phase-1 { id: id } { claim: false})
    (map-set awards { phase: u1, id: id } { type: "tokens" , claim: false })
    (print {
      result: "congrats",
      asset: (contract-of asset),
      amount: amount,
      nft-id: id,
      user: contract-caller
    })
  (ok true)))

;; Claim FT / Phase 2
(define-public (claim-tokens-phase-2 (asset <ft-trait>) (id uint) (amount uint))
  (begin
    (asserts! (is-eq (unwrap! (unwrap! (contract-call? .skullcoin-competitive-bb-phase2 get-owner id) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
    (asserts! (is-eq (get claim (unwrap-panic (map-get? tokens-phase-2 { id: id }))) true) ERR-NOT-TOKENS-OR-CLAIMED)
    (try! (send-ft-to-winner asset amount tx-sender))
    (map-set tokens-phase-2 { id: id } { claim: false})
    (map-set awards { phase: u2, id: id } { type: "tokens" , claim: false })
    (print {
      result: "congrats",
      asset: (contract-of asset),
      amount: amount,
      nft-id: id,
      user: contract-caller
    })
  (ok true)))

;; Claim FT / Phase 3
(define-public (claim-tokens-phase-3 (asset <ft-trait>) (id uint) (amount uint))
  (begin
    (asserts! (is-eq (unwrap! (unwrap! (contract-call? .skullcoin-competitive-bb-phase3 get-owner id) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
    (asserts! (is-eq (get claim (unwrap-panic (map-get? tokens-phase-3 { id: id }))) true) ERR-NOT-TOKENS-OR-CLAIMED)
    (try! (send-ft-to-winner asset amount tx-sender))
    (map-set tokens-phase-3 { id: id } { claim: false})
    (map-set awards { phase: u3, id: id } { type: "tokens" , claim: false })
    (print {
      result: "congrats",
      asset: (contract-of asset),
      amount: amount,
      nft-id: id,
      user: contract-caller
    })
  (ok true)))

;; Burn 5 NFTs / Phase 1
(define-public (burn-phase-1 (id1 uint) (id2 uint) (id3 uint) (id4 uint) (id5 uint))
  (begin
    (asserts! (is-eq (unwrap! (unwrap! (contract-call? .skullcoin-competitive-bb-phase1 get-owner id1) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
    (asserts! (is-eq (unwrap! (unwrap! (contract-call? .skullcoin-competitive-bb-phase1 get-owner id2) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
    (asserts! (is-eq (unwrap! (unwrap! (contract-call? .skullcoin-competitive-bb-phase1 get-owner id3) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
    (asserts! (is-eq (unwrap! (unwrap! (contract-call? .skullcoin-competitive-bb-phase1 get-owner id4) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
    (asserts! (is-eq (unwrap! (unwrap! (contract-call? .skullcoin-competitive-bb-phase1 get-owner id5) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
    (try! (contract-call? .skullcoin-competitive-bb-phase1 transfer id1 tx-sender BURN-WALLET))
    (try! (contract-call? .skullcoin-competitive-bb-phase1 transfer id2 tx-sender BURN-WALLET))
    (try! (contract-call? .skullcoin-competitive-bb-phase1 transfer id3 tx-sender BURN-WALLET))
    (try! (contract-call? .skullcoin-competitive-bb-phase1 transfer id4 tx-sender BURN-WALLET))
    (try! (contract-call? .skullcoin-competitive-bb-phase1 transfer id5 tx-sender BURN-WALLET))
    (try! (contract-call? .skullcoin-competitive-bb-phase2 mint tx-sender))
    (try! (contract-call? .skullcoin-competitive-bb-phase2 mint tx-sender))
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
    (asserts! (is-eq (unwrap! (unwrap! (contract-call? .skullcoin-competitive-bb-phase2 get-owner id1) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
    (asserts! (is-eq (unwrap! (unwrap! (contract-call? .skullcoin-competitive-bb-phase2 get-owner id2) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
    (asserts! (is-eq (unwrap! (unwrap! (contract-call? .skullcoin-competitive-bb-phase2 get-owner id3) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
    (asserts! (is-eq (unwrap! (unwrap! (contract-call? .skullcoin-competitive-bb-phase2 get-owner id4) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
    (asserts! (is-eq (unwrap! (unwrap! (contract-call? .skullcoin-competitive-bb-phase2 get-owner id5) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
    (try! (contract-call? .skullcoin-competitive-bb-phase2 transfer id1 tx-sender BURN-WALLET))
    (try! (contract-call? .skullcoin-competitive-bb-phase2 transfer id2 tx-sender BURN-WALLET))
    (try! (contract-call? .skullcoin-competitive-bb-phase2 transfer id3 tx-sender BURN-WALLET))
    (try! (contract-call? .skullcoin-competitive-bb-phase2 transfer id4 tx-sender BURN-WALLET))
    (try! (contract-call? .skullcoin-competitive-bb-phase2 transfer id5 tx-sender BURN-WALLET))
    (try! (contract-call? .skullcoin-competitive-bb-phase3 mint tx-sender))
    (try! (contract-call? .skullcoin-competitive-bb-phase3 mint tx-sender))
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

;; Burn 5 NFTs / Phase 3
(define-public (burn-phase-3 (id1 uint) (id2 uint) (id3 uint) (id4 uint) (id5 uint))
  (begin
    (asserts! (is-eq (unwrap! (unwrap! (contract-call? .skullcoin-competitive-bb-phase3 get-owner id1) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
    (asserts! (is-eq (unwrap! (unwrap! (contract-call? .skullcoin-competitive-bb-phase3 get-owner id2) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
    (asserts! (is-eq (unwrap! (unwrap! (contract-call? .skullcoin-competitive-bb-phase3 get-owner id3) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
    (asserts! (is-eq (unwrap! (unwrap! (contract-call? .skullcoin-competitive-bb-phase3 get-owner id4) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
    (asserts! (is-eq (unwrap! (unwrap! (contract-call? .skullcoin-competitive-bb-phase3 get-owner id5) ERR-NOT-OWNER) ERR-NOT-OWNER) tx-sender) ERR-NOT-OWNER)
    (try! (contract-call? .skullcoin-competitive-bb-phase3 transfer id1 tx-sender BURN-WALLET))
    (try! (contract-call? .skullcoin-competitive-bb-phase3 transfer id2 tx-sender BURN-WALLET))
    (try! (contract-call? .skullcoin-competitive-bb-phase3 transfer id3 tx-sender BURN-WALLET))
    (try! (contract-call? .skullcoin-competitive-bb-phase3 transfer id4 tx-sender BURN-WALLET))
    (try! (contract-call? .skullcoin-competitive-bb-phase3 transfer id5 tx-sender BURN-WALLET))
    (try! (contract-call? .skullcoin-competitive-bb-phase4 mint tx-sender))
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

;; Internal - Mint NFT via whitelist
(define-private (wl-mint (new-owner principal))
  (let ((wl-balance (get-wl-balance new-owner)))
    (asserts! (> wl-balance u0) ERR-NO-WL-REMAINING)
    (map-set wl-count new-owner (- wl-balance u1))
    (try! (contract-call? .skullcoin-competitive-bb-phase1 mint new-owner))
  (ok true)))

;; Internal - Mint NFT via public
(define-private (mint (new-owner principal))
  (begin
    (asserts! (var-get sale-active) ERR-SALE-NOT-ACTIVE)
    (try! (contract-call? .skullcoin-competitive-bb-phase1 mint new-owner))
  (ok true)))

;; Internal - Send STX to winner player in claim function for treasure/chest/stx NFTs
(define-private (send-stx-to-winner (amount uint) (player principal))
  (begin
    (try! (as-contract (stx-transfer? amount tx-sender player)))
  (ok true)))

;; Internal - Send SIP-010 tokens to winner player in claim function for tokens NFTs
(define-private (send-ft-to-winner (asset <ft-trait>) (amount uint) (player principal))
  (begin
    (try! (as-contract (contract-call? asset transfer amount tx-sender player none)))
  (ok true)))

;; Internal - Pick id with RNG based on VRF
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

;; Internal - Set VRF from previous block
(define-private (set-vrf)    
  (var-set last-vrf (sha512 (unwrap-panic (get-block-info? vrf-seed (- block-height u1))))))

;; Register this contract as allowed to mint
(as-contract (contract-call? .skullcoin-competitive-bb-phase1 set-mint-address))
(as-contract (contract-call? .skullcoin-competitive-bb-phase2 set-mint-address))
(as-contract (contract-call? .skullcoin-competitive-bb-phase3 set-mint-address))
(as-contract (contract-call? .skullcoin-competitive-bb-phase4 set-mint-address))