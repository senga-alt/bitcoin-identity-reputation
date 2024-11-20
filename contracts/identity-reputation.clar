;; title: Identity and Reputation Management System
;; summary: A smart contract for managing decentralized identities and their reputation scores.
;; description: This smart contract provides functionalities to create and manage decentralized identities, update and decay reputation scores based on predefined actions, and verify reputation thresholds for external platforms. It includes error handling, storage maps for identities and reputation actions, and initialization functions to set up reputation actions.


;; Errors
(define-constant ERR-UNAUTHORIZED (err u100))
(define-constant ERR-INVALID-PARAMETERS (err u101))
(define-constant ERR-IDENTITY-EXISTS (err u102))
(define-constant ERR-IDENTITY-NOT-FOUND (err u103))
(define-constant ERR-INSUFFICIENT-REPUTATION (err u104))
(define-constant ERR-MAX-REPUTATION-REACHED (err u105))

;; Storage Maps
(define-map identities 
  {owner: principal}
  {
    did: (string-ascii 50),  ;; Decentralized Identity
    reputation-score: uint,
    created-at: uint,
    last-updated: uint
  }
)

(define-map reputation-actions
  {
    action-type: (string-ascii 50)
  }
  {
    multiplier: uint
  }
)

;; Constants
(define-constant MAX-REPUTATION-SCORE u1000)
(define-constant MIN-REPUTATION-SCORE u0)
(define-constant REPUTATION-DECAY-RATE u10)  ;; 10% decay per period

;; Initialization Function
(define-public (initialize-reputation-actions)
  (begin
    (map-set reputation-actions 
      {action-type: "governance-vote"} 
      {multiplier: u5}
    )
    (map-set reputation-actions 
      {action-type: "contract-fulfillment"} 
      {multiplier: u10}
    )
    (map-set reputation-actions 
      {action-type: "community-contribution"} 
      {multiplier: u7}
    )
    (ok true)
  )
)

;; Create Identity
(define-public (create-identity (did (string-ascii 50)))
  (let 
    (
      (sender tx-sender)
      (current-block-height block-height)
    )
    (begin
      ;; Check if identity already exists
      (asserts! (is-none (map-get? identities {owner: sender})) 
        (err ERR-IDENTITY-EXISTS))
      
      ;; Validate DID
      (asserts! (> (len did) u5) 
        (err ERR-INVALID-PARAMETERS))
      
      ;; Create identity
      (map-set identities 
        {owner: sender}
        {
          did: did,
          reputation-score: u50,  ;; Starting reputation
          created-at: current-block-height,
          last-updated: current-block-height
        }
      )
      (ok did)
    )
  )
)

;; Update Reputation
(define-public (update-reputation 
  (owner principal) 
  (action-type (string-ascii 50))
)
  (let 
    (
      (current-identity
        (unwrap! 
          (map-get? identities {owner: owner}) 
          (err ERR-IDENTITY-NOT-FOUND)
        )
      )
      (action-multiplier 
        (default-to u0 
          (get multiplier 
            (map-get? reputation-actions {action-type: action-type})
          )
        )
      )
      (current-score (get reputation-score current-identity))
      (updated-score 
        (if (< (+ current-score action-multiplier) MAX-REPUTATION-SCORE)
            (+ current-score action-multiplier)
            MAX-REPUTATION-SCORE
        )
      )
    )
    (begin
      ;; Prevent unauthorized updates
      (asserts! (is-eq tx-sender owner) 
        (err ERR-UNAUTHORIZED))
      
      ;; Update identity record
      (map-set identities 
        {owner: owner}
        (merge current-identity {
          reputation-score: updated-score,
          last-updated: block-height
        })
      )
      (ok updated-score)
    )
  )
)