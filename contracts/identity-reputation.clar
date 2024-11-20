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