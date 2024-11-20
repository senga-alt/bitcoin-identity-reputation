# Identity and Reputation Management System

A decentralized smart contract system for managing digital identities and reputation scores on the Stacks blockchain. This system enables users to create verifiable digital identities and build reputation through various platform interactions.

## Overview

The Identity and Reputation Management System is designed to provide a transparent and decentralized approach to identity verification and reputation tracking. It implements a dynamic scoring system that rewards positive actions while incorporating natural score decay to maintain relevance and encourage continuous participation.

## Features

- **Decentralized Identity Creation**: Users can create their own digital identity with a unique DID (Decentralized Identifier)
- **Dynamic Reputation Scoring**: Reputation scores that update based on user actions
- **Automated Score Decay**: Time-based reputation decay to ensure scores remain current
- **Configurable Action Multipliers**: Different actions have different impacts on reputation
- **External Verification System**: APIs for external platforms to verify user reputation
- **Built-in Security Controls**: Authorization checks and parameter validation

## Technical Specifications

### Constants

- Maximum Reputation Score: 1000
- Minimum Reputation Score: 0
- Reputation Decay Rate: 10% per period
- Starting Reputation Score: 50

### Storage Maps

1. **Identities Map**

   - Owner (Principal)
   - DID (String ASCII, max 50 chars)
   - Reputation Score (Uint)
   - Created At (Block Height)
   - Last Updated (Block Height)

2. **Reputation Actions Map**
   - Action Type (String ASCII, max 50 chars)
   - Multiplier (Uint)

### Error Codes

| Code | Description                |
| ---- | -------------------------- |
| u100 | Unauthorized access        |
| u101 | Invalid parameters         |
| u102 | Identity already exists    |
| u103 | Identity not found         |
| u104 | Insufficient reputation    |
| u105 | Maximum reputation reached |

## Public Functions

### `create-identity`

Creates a new digital identity for the caller.

```clarity
(define-public (create-identity (did (string-ascii 50))))
```

### `update-reputation`

Updates the reputation score based on specific actions.

```clarity
(define-public (update-reputation (action-type (string-ascii 50))))
```

### `decay-reputation`

Applies time-based decay to the reputation score.

```clarity
(define-public (decay-reputation))
```

### Read-Only Functions

### `get-reputation`

Retrieves the complete identity information for a given principal.

```clarity
(define-read-only (get-reputation (owner principal)))
```

### `verify-reputation`

Verifies if a user meets a minimum reputation threshold.

```clarity
(define-read-only (verify-reputation (owner principal) (min-reputation-threshold uint)))
```

## Reputation Actions

The system comes pre-configured with the following reputation actions:

| Action Type            | Multiplier |
| ---------------------- | ---------- |
| Governance Vote        | 5          |
| Contract Fulfillment   | 10         |
| Community Contribution | 7          |

## Installation and Deployment

1. Install the [Clarinet](https://github.com/hirosystems/clarinet) development environment
2. Clone this repository
3. Deploy using Clarinet:

```bash
clarinet deploy
```

## Usage Example

```clarity
;; Create a new identity
(contract-call? .identity-system create-identity "did:example:123")

;; Update reputation after a governance vote
(contract-call? .identity-system update-reputation "governance-vote")

;; Check current reputation
(contract-call? .identity-system get-reputation tx-sender)
```

## Security Considerations

- All reputation updates require authorization from the identity owner
- Reputation scores are bounded between 0 and 1000
- Natural decay prevents reputation score hoarding
- Built-in parameter validation prevents invalid inputs
- Identity creation is limited to one per principal

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Support

For support and questions, please open an issue in the repository or contact the maintainers.
