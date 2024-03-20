(impl-trait 'ST3T54N6G4HN7GPBCYMSDKP4W00C45X19GNH7C0T6.sip-010-trait-ft-standard.sip-010-trait)

(define-fungible-token TEST-SKUL u2000000000000000)

;; Errors
(define-constant ERR-NOT-AUTHORIZED (err u301))
(define-constant ERR-MINT-ALREADY-SET (err u302))
(define-constant ERR-MINTED-OUT (err u303))

;; Constants
(define-constant CONTRACT-OWNER tx-sender)

;; Variables
(define-data-var token-uri (optional (string-utf8 256)) none)
(define-data-var total-minted uint u0)
(define-data-var total-burned uint u0)
(define-data-var last-mint-tx-id uint u0)
(define-data-var last-burn-tx-id uint u0)

;; Maps
(define-map mint-address bool principal)
(define-map minters { 
                        mint-tx-id: uint 
                    }
                    { 
                        wallet: principal,
                        amount: uint
                    }
)
(define-map burners { 
                        burn-tx-id: uint 
                    }
                    { 
                        wallet: principal,
                        amount: uint
                    }
)

;; Mint some token amount
(define-public (mint (amount uint) (recipient principal))
    (begin
        (asserts! (called-from-mint) ERR-NOT-AUTHORIZED)
        (try! (ft-mint? TEST-SKUL amount recipient))
        (var-set total-minted (+ (var-get total-minted) amount))
        (map-set minters { mint-tx-id: (var-get last-mint-tx-id) } { wallet: tx-sender, amount: amount })
        (print (var-get total-minted))
        (ok true)
    )
)

;; Burn some token amount
(define-public (burn (burn-amount uint) (sender principal))
    (begin
        (asserts! (called-from-mint) ERR-NOT-AUTHORIZED)
        (try! (ft-burn? TEST-SKUL burn-amount sender))
        (var-set total-burned (+ (var-get total-burned) burn-amount))
        (map-set burners { burn-tx-id: (var-get last-burn-tx-id) } { wallet: tx-sender, amount: burn-amount })
        (print (var-get total-burned))
        (ok true)
    )
)

;; Transfer token from sender to recipient
(define-public (transfer (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
    (if (is-eq tx-sender sender)
        (begin
            (try! (ft-transfer? TEST-SKUL amount sender recipient))
            (print memo)
            (ok true)
        )
        (err u4)
    )
)

;; Set token URI (only contract owner)
(define-public (set-token-uri (value (string-utf8 256)))
    (if (is-eq tx-sender CONTRACT-OWNER)
        (ok (var-set token-uri (some value)))
        (err ERR-NOT-AUTHORIZED)
    )
)

;; Set mint address
(define-public (set-mint-address)
    (let
        ((the-mint (map-get? mint-address true)))
        (asserts! (and (is-none the-mint) (map-insert mint-address true tx-sender)) ERR-MINT-ALREADY-SET)
        (ok tx-sender)
    )
)

;; Update mint address (only contract owner)
(define-public (update-mint-address)
    (begin
        (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
        (map-delete mint-address true)
        (ok true)
    )
)

;; Manage the Mint
(define-private (called-from-mint)
    (let
        ((the-mint (unwrap! (map-get? mint-address true) false)))
        (is-eq contract-caller the-mint)
    )
)

;; Get token name
(define-read-only (get-name)
    (ok "TETS-SKULLCOIN")
)

;; Get token symbol
(define-read-only (get-symbol)
    (ok "TEST-SKUL")
)

;; Get decimals
(define-read-only (get-decimals)
    (ok u8)
)

;; Get user (principal) balance
(define-read-only (get-balance (who principal))
    (ok (ft-get-balance TEST-SKUL who))
)

;; Get total supply
(define-read-only (get-total-supply)
    (ok (ft-get-supply TEST-SKUL))
)

;; Get token URI
(define-read-only (get-token-uri)
    (ok (var-get token-uri))
)

;; Get minted amount
(define-read-only (get-minted-amount)
    (ok (var-get total-minted))
)

;; Get burned amount
(define-read-only (get-burned-amount)
    (ok (var-get total-burned))
)