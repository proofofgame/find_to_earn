;; Skullcoin | Competitive | Game #2 | Curiosity Shop | v.1.0.0
;; skullco.in

;; TODO
;; 1. Add limits for clues amount by hunt

;; Traits
(use-trait ft-trait 'SP3FBR2AGK5H9QBDH3EEN6DF8EK8JY7RX8QJ5SVTE.sip-010-trait-ft-standard.sip-010-trait)

;; Constants and Errors
(define-constant CONTRACT-OWNER tx-sender)
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-SALE-NOT-ACTIVE (err u101))
(define-constant ERR-ALREADY-PURCHASED (err u102))
(define-constant ERR-NOT-CLAIMED-EARLY-CLUES (err u103))

;; Variables
(define-data-var sale-for-clue-1-active bool false)
(define-data-var sale-for-clue-2-3-active bool false)

;; Maps
(define-map clues { wallet: principal, hunt-id: uint } { clue-1: bool, clue-2: bool, clue-3: bool })
(define-map clues-prices { hunt: uint } { clue-1-price: uint, clue-2-price: uint, clue-3-price: uint })

;; Check sales active
(define-read-only (clue-1-sale-enabled)
    (var-get sale-for-clue-1-active))

;; Check sales for clue 2 & 3 active
(define-read-only (clue-2-3-sale-enabled)
    (var-get sale-for-clue-2-3-active))

;; Get first clue price
(define-read-only (get-price-clue-1 (hunt uint))
    (get clue-1-price (unwrap-panic (map-get? clues-prices { hunt: hunt }))))

;; Get second clue price
(define-read-only (get-price-clue-2 (hunt uint))
    (get clue-2-price (unwrap-panic (map-get? clues-prices { hunt: hunt }))))

;; Get third clue price
(define-read-only (get-price-clue-3 (hunt uint))
    (get clue-3-price (unwrap-panic (map-get? clues-prices { hunt: hunt }))))

;; Get clues status by principal and hunt
(define-read-only (get-clues-status (wallet principal) (hunt uint))
    (unwrap-panic (map-get? clues (tuple (wallet wallet) (hunt-id hunt)))))

;; Set sale flag for clue 1 (only contract owner)
(define-public (flip-clue-1-sale)
    (begin
        (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
        (var-set sale-for-clue-1-active (not (var-get sale-for-clue-1-active)))
    (ok (var-get sale-for-clue-1-active))))

;; Set sale flag for clue 2 & 3 (only contract owner)
(define-public (flip-clue-2-3-sale)
   (begin
        (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
        (var-set sale-for-clue-2-3-active (not (var-get sale-for-clue-2-3-active)))
    (ok (var-get sale-for-clue-2-3-active))))

;; Withdrawal SIP-010 tokens from contract (only contract owner)
(define-public (withdraw-ft (asset <ft-trait>) (amount uint))
    (begin
        (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
        (try! (as-contract (contract-call? asset transfer amount tx-sender CONTRACT-OWNER none)))
    (ok true)))

;; Set price for clues (only contract owner)
(define-public (set-price-for-clues (hunt uint) (clue-1-price uint) (clue-2-price uint) (clue-3-price uint))
    (begin
        (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
        (map-set clues-prices { hunt: hunt } { clue-1-price: clue-1-price, clue-2-price: clue-2-price, clue-3-price: clue-3-price })
        (print {
            hunt: hunt,
            clue-1-price: clue-1-price,
            clue-2-price: clue-2-price,
            clue-3-price: clue-3-price
        })
    (ok true)))

;; Buy first clue
(define-public (buy-clue-1 (hunt uint))
    (let
        ((amount (get clue-1-price (unwrap-panic (map-get? clues-prices { hunt: hunt })))))
            (asserts! (var-get sale-for-clue-1-active) ERR-SALE-NOT-ACTIVE)
            (try! (contract-call? 'SM3VDXK3WZZSA84XXFKAFAF15NNZX32CTSG82JFQ4.sbtc-token transfer amount tx-sender 'SP3T54N6G4HN7GPBCYMSDKP4W00C45X19GQ4VT13Y.skullcoin-competitive-g2-curiosity-shop none))
            (map-set clues { wallet: tx-sender, hunt-id: hunt } { clue-1: true, clue-2: false, clue-3: false })
            (print {
                result: "clue 1",
                hunt: hunt,
                asset: "sBTC",
                amount: amount,
                user: contract-caller
            })
    (ok true))
)   

;; Buy second clue
(define-public (buy-clue-2 (hunt uint))
    (let
        ((amount (get clue-2-price (unwrap-panic (map-get? clues-prices { hunt: hunt })))))
            (asserts! (var-get sale-for-clue-2-3-active) ERR-SALE-NOT-ACTIVE)
            (asserts! (is-eq (get clue-2 (unwrap-panic (map-get? clues { wallet: tx-sender, hunt-id: hunt }))) false) ERR-ALREADY-PURCHASED)
            (try! (contract-call? 'SM3VDXK3WZZSA84XXFKAFAF15NNZX32CTSG82JFQ4.sbtc-token transfer amount tx-sender 'SP3T54N6G4HN7GPBCYMSDKP4W00C45X19GQ4VT13Y.skullcoin-competitive-g2-curiosity-shop none))
            (map-set clues { wallet: tx-sender, hunt-id: hunt } { clue-1: (get clue-1 (unwrap-panic (map-get? clues { wallet: tx-sender, hunt-id: hunt }))), clue-2: true, clue-3: false })
            (print {
                result: "clue 2",
                hunt: hunt,
                asset: "sBTC",
                amount: amount,
                user: contract-caller
            })
    (ok true))
)

;; Buy third clue
(define-public (buy-clue-3 (hunt uint))
    (let
        ((amount (get clue-3-price (unwrap-panic (map-get? clues-prices { hunt: hunt })))))
            (asserts! (var-get sale-for-clue-2-3-active) ERR-SALE-NOT-ACTIVE)
            (asserts! (is-eq (get clue-1 (unwrap-panic (map-get? clues { wallet: tx-sender, hunt-id: hunt }))) true) ERR-NOT-CLAIMED-EARLY-CLUES)
            (asserts! (is-eq (get clue-2 (unwrap-panic (map-get? clues { wallet: tx-sender, hunt-id: hunt }))) true) ERR-NOT-CLAIMED-EARLY-CLUES)
            (asserts! (is-eq (get clue-3 (unwrap-panic (map-get? clues { wallet: tx-sender, hunt-id: hunt }))) false) ERR-ALREADY-PURCHASED)
            (try! (contract-call? 'SM3VDXK3WZZSA84XXFKAFAF15NNZX32CTSG82JFQ4.sbtc-token transfer amount tx-sender 'SP3T54N6G4HN7GPBCYMSDKP4W00C45X19GQ4VT13Y.skullcoin-competitive-g2-curiosity-shop none))
            (map-set clues { wallet: tx-sender, hunt-id: hunt } { clue-1: (get clue-1 (unwrap-panic (map-get? clues { wallet: tx-sender, hunt-id: hunt }))), clue-2: (get clue-2 (unwrap-panic (map-get? clues { wallet: tx-sender, hunt-id: hunt }))), clue-3: true })
            (print {
                result: "clue 3",
                hunt: hunt,
                asset: "sBTC",
                amount: amount,
                user: contract-caller
            })
    (ok true))
)