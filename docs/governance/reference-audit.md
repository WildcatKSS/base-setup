# Reference Audit

## Scope

This audit checks repository file references after correcting the README start command and stale references.

## Root Items

- `.env.example`
- `.github`
- `.gitignore`
- `CLAUDE.md`
- `CONTRIBUTING.md`
- `LICENSE`
- `README.md`
- `docker-compose.yml`
- `docs`
- `scripts`

## Reference Check

Broken references found: 0

No broken references found.

## README Start Command

The recommended first Claude Code command now references existing files:

- `CLAUDE.md`
- `docs/governance/governance-index.md`
- `docs/governance/repository-memory-policy.md`
- `docs/project-status.md`
- `docs/context/current-state.md`
- `docs/context/next-session.md`
- `docs/prompts/phase-0-governance.md`

## Heading Check

Heading issues found: 0

No heading issues found.

## Version Reference Check

Internal version or score references found: 0

No internal version or score references found.

## Duplicate Basenames

Duplicate markdown basenames found: 1

- `definition-of-done.md`: docs/definition-of-done.md, docs/governance/definition-of-done.md

## Result

The repository references are consistent in the audited scope.
