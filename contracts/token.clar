(impl-trait 'SP3FBR2AGK5H9QBDH3EEN6DF8EK8JY7RX8QJ5SVTE.sip-010-trait-ft-standard.sip-010-trait)

(define-fungible-token SKUL u2000000000000000)

;; Errors
(define-constant ERR-NOT-AUTHORIZED (err u301))
(define-constant ERR-MINT-ALREADY-SET (err u302))

;; Constants
(define-constant CONTRACT-OWNER tx-sender)

;; Variables
(define-data-var token-uri (optional (string-utf8 256)) none)

;; Maps
(define-map mint-address bool principal)

(define-public (mint (amount uint) (recipient principal))
    (begin
        (asserts! (called-from-mint) ERR-NOT-AUTHORIZED)
        (ft-mint? SKUL amount recipient)
    )
)

(define-public (transfer (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
    (if (is-eq tx-sender sender)
        (begin
            (try! (ft-transfer? SKUL amount sender recipient))
            (print memo)
            (ok true)
        )
        (err u4)
    )
)

(define-public (set-token-uri (value (string-utf8 256)))
    (if (is-eq tx-sender CONTRACT-OWNER)
        (ok (var-set token-uri (some value)))
        (err ERR-NOT-AUTHORIZED)
    )
)

(define-public (burn (burn-amount uint) (sender principal))
    (begin
        (asserts! (called-from-mint) ERR-NOT-AUTHORIZED)
        (ft-burn? SKUL burn-amount sender)
    )
)

(define-read-only (get-name)
    (ok "SKULLCOIN")
)

(define-read-only (get-symbol)
    (ok "SKUL")
)

(define-read-only (get-decimals)
    (ok u8)
)

(define-read-only (get-balance (who principal))
    (ok (ft-get-balance SKUL who))
)

(define-read-only (get-total-supply)
    (ok (ft-get-supply SKUL))
)

(define-read-only (get-token-uri)
    (ok (var-get token-uri))
)

;; Set mint address
(define-public (set-mint-address)
  (let ((the-mint (map-get? mint-address true)))
    (asserts! (and (is-none the-mint)
              (map-insert mint-address true tx-sender))
                ERR-MINT-ALREADY-SET)
    (ok tx-sender)))

;; Manage the Mint
(define-private (called-from-mint)
  (let ((the-mint
          (unwrap! (map-get? mint-address true)
                    false)))
    (is-eq contract-caller the-mint)))