;; Skullcoin | Quests | v.1.0.0
;; skullco.in

;; Traits
(use-trait ft-trait 'SP3FBR2AGK5H9QBDH3EEN6DF8EK8JY7RX8QJ5SVTE.sip-010-trait-ft-standard.sip-010-trait)

;; Constants and Errors
(define-constant CONTRACT-OWNER tx-sender)
(define-constant BURN-WALLET 'SP000000000000000000002Q6VF78)
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-SALE-NOT-ACTIVE (err u101))
(define-constant ERR-OUT-OF-SLOTS (err u102))
(define-constant ERR-ALREADY-IN-QUEST (err u103))

;; Variables
(define-data-var sale-active bool false)
(define-data-var remaining-slots uint u0)
(define-data-var current-quest uint u0)
(define-data-var price uint u0)

;; Maps
(define-map players { quest-id: uint } { players-list: (string-ascii 5000) })
(define-map data { quest-id: uint, player: principal } { claim: bool })

;; Check sales active
(define-read-only (sale-enabled)
    (var-get sale-active))

;; Get remaining slots
(define-read-only (get-remaining-slots)
    (var-get remaining-slots))

;; Get current quest
(define-read-only (get-current-quest)
    (var-get current-quest))

;; Get price in quest
(define-read-only (get-price)
    (var-get price))

;; Get players by quest id
(define-read-only (get-quest-players (quest uint))
    (unwrap-panic (get players-list (map-get? players { quest-id: quest}))))

;; Set sale flag (only contract owner)
(define-public (flip-sale)
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (var-set sale-active (not (var-get sale-active)))
    (ok (var-get sale-active))))

;; Withdrawal SIP-010 tokens from contract (only contract owner)
(define-public (withdraw-ft (asset <ft-trait>) (amount uint))
    (begin
        (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
        (try! (as-contract (contract-call? asset transfer amount tx-sender CONTRACT-OWNER none)))
    (ok true)))

;; Burn SIP-010 tokens from contract (only contract owner)
(define-public (burn-ft (asset <ft-trait>) (amount uint))
    (begin
        (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
        (try! (as-contract (contract-call? asset transfer amount tx-sender BURN-WALLET none)))
    (ok true)))

;; Initialize quest, set params (only contract owner)
(define-public (initialize-quest (quest-id uint) (quest-price uint) (slots uint))
    (begin
        (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
        (var-set sale-active true)
        (var-set current-quest quest-id)
        (var-set price quest-price)
        (var-set remaining-slots slots)
        (map-set players { quest-id: quest-id } { players-list: "quest-players:" })
        (print {
            sales: (var-get sale-active),
            quest: (var-get current-quest),
            price: (var-get price),
            total-players: (var-get remaining-slots)
        })
    (ok true)))

;; Buy participation on quest
(define-public (sign-up (memo (string-ascii 100)))
    (begin
        (asserts! (var-get sale-active) ERR-SALE-NOT-ACTIVE)
        (asserts! (not (is-eq (var-get remaining-slots) u0)) ERR-OUT-OF-SLOTS)
        (asserts! (is-eq (unwrap-panic (get claim (map-get? data (tuple (quest-id (var-get current-quest)) (player tx-sender))))) true) ERR-ALREADY-IN-QUEST)
        (try! (contract-call? 'SP3BRXZ9Y7P5YP28PSR8YJT39RT51ZZBSECTCADGR.skullcoin-stxcity transfer (var-get amount) tx-sender 'SP3T54N6G4HN7GPBCYMSDKP4W00C45X19GQ4VT13Y.skullcoin-quests none))
        (var-set remaining-slots (- (var-get remaining-slots) u1))
        (map-set players { quest-id: (var-get current-quest) } { players-list: (unwrap-panic (as-max-len? (concat (get players-list (unwrap-panic (map-get? players { quest-id: (var-get current-quest)}))) (concat memo ";")) u5000)) } )
        (map-set data { quest-id: (var-get current-quest), player: tx-sender } { claim: true } )
        (print {
            result: "participation successfully purchased",
            quest-id: (var-get current-quest),
            asset: "skullcoin",
            price: (var-get price),
            memo: memo,
            user: contract-caller
        })
    (ok true)))