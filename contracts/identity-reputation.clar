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