# Definition of Done

A task, feature, release, or phase is only done when all relevant criteria are met.

## Business

- Business justification documented
- Customer problem linked
- Scope-control decision made
- Unit economics impact known

## Product

- Acceptance criteria met
- PRD updated if needed
- Out-of-scope items documented

## Code

- Compiles
- Type checks
- Lints
- No unapproved TODOs
- No hardcoded secrets
- No demo-only implementation in production paths

## Tests

- Unit tests where relevant
- Integration tests where relevant
- E2E tests for critical flows
- Regression test for bug fixes

## Security

- Input validation
- Authorization checks
- Sensitive data protected
- Dependency risk reviewed
- Logging avoids secrets/PII

## Operations

- Logging present
- Monitoring impact known
- Deployment impact known
- Rollback path known

## Documentation

- project-status.md updated
- current-state.md updated
- next-session.md updated
- ADR updated if needed
