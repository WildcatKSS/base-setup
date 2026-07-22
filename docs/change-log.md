# Change Log

## Unreleased

## Added
- Product-neutral Claude Code SaaS starter

## Changed
- Consolidated Definition of Done and ADR template to single canonical versions (ADR-001)
- Aligned CLAUDE.md governance hierarchy with the governance charter
- Rewrote README to a single start procedure
- Hardened governance CI checks: anchored keyword matching, dependency-bot exemption, real freshness dates

## Removed
- Pre-committed stack files (docker-compose.yml, .env.example) to restore product neutrality
- One-off governance audit snapshot reports
- Empty pre-numbered ADR stubs
- Redundant decision-template.md; decision format is owned by the decision framework (ADR-002)

## Fixed
- MVP Gate CI check was vacuous: it matched the word "Approved" in the unapproved template's option line; it now requires a literal `MVP Gate Approved: Yes` (ADR-002)

## Security
- Expanded security requirements to a product-neutral B2B SaaS baseline: multi-tenant isolation, session management, rate limiting, encryption, audit logging (ADR-002)
- Added a baseline multi-tenant SaaS threat model (ADR-002)
