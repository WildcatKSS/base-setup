#!/usr/bin/env bash
set -euo pipefail

BASE_REF="${BASE_REF:-origin/main}"
STRICT="${STRICT_GOVERNANCE:-true}"

fail() {
  echo "❌ $1"
  exit 1
}

warn() {
  echo "⚠️  $1"
}

pass() {
  echo "✅ $1"
}

required=(
  "CLAUDE.md"
  "README.md"
  "docs/security-requirements.md"
  "docs/governance/governance-charter.md"
  "docs/governance/source-of-truth.md"
  "docs/governance/documentation-style-guide.md"
  "docs/governance/lean-engineering.md"
  "docs/governance/definition-of-ready.md"
  "docs/governance/definition-of-done.md"
  "docs/governance/phase-gates.md"
  "docs/governance/decision-framework.md"
  "docs/governance/change-management.md"
  "docs/governance/repository-memory-policy.md"
  "docs/governance/founder-override.md"
  "docs/governance/governance-index.md"
  "docs/project-status.md"
  "docs/scope-control.md"
  "docs/unit-economics.md"
  "docs/product/mvp-gate.md"
  "docs/context/current-state.md"
  "docs/context/decisions-summary.md"
  "docs/context/open-issues.md"
  "docs/context/next-session.md"
)

for file in "${required[@]}"; do
  [[ -f "$file" ]] || fail "Missing required governance file: $file"
done
pass "Required governance files exist."

grep -q "lean-engineering.md" CLAUDE.md || fail "CLAUDE.md must reference docs/governance/lean-engineering.md"
grep -q "repository-memory-policy.md" CLAUDE.md || fail "CLAUDE.md must reference docs/governance/repository-memory-policy.md"
pass "CLAUDE.md references core governance."

for file in docs/project-status.md docs/context/current-state.md docs/context/next-session.md docs/scope-control.md docs/unit-economics.md docs/product/mvp-gate.md; do
  [[ -s "$file" ]] || fail "$file is empty."
done
pass "Critical context and governance documents are non-empty."

if find . \( -name ".env" -o -name ".env.local" -o -name ".env.production" \) -not -path "./node_modules/*" | grep -q .; then
  fail "Committed environment file detected."
fi
pass "No committed environment files detected."

# Determine changed files if possible.
changed=""
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  if git rev-parse "$BASE_REF" >/dev/null 2>&1; then
    changed="$(git diff --name-only "$BASE_REF"...HEAD || true)"
  else
    changed="$(git diff --name-only HEAD~1...HEAD 2>/dev/null || true)"
  fi
fi

if [[ -z "$changed" ]]; then
  warn "No git diff available; running baseline governance checks only."
else
  echo "Changed files:"
  echo "$changed"

  # Context memory must be updated in meaningful PRs.
  if echo "$changed" | grep -E '^(src/|prisma/|docs/|\.github/workflows/|package.json|pnpm-lock.yaml|package-lock.json|yarn.lock|docker-compose.yml)' >/dev/null; then
    echo "$changed" | grep -E '^(docs/project-status.md|docs/context/current-state.md|docs/context/next-session.md)' >/dev/null \
      || fail "Meaningful changes require updates to project-status.md, current-state.md or next-session.md."
  fi

  # Product implementation requires MVP Gate approval.
  if echo "$changed" | grep -E '^(src/|prisma/)' >/dev/null; then
    grep -Eiq 'Decision:[[:space:]]*Approved|MVP Gate Approved:[[:space:]]*Yes|Approved' docs/product/mvp-gate.md \
      || fail "Product implementation changed, but MVP Gate is not marked Approved."

    echo "$changed" | grep -E '^docs/scope-control.md$' >/dev/null \
      || fail "Product implementation changed; docs/scope-control.md must be updated or reviewed in the same PR."

    echo "$changed" | grep -E '^docs/context/' >/dev/null \
      || fail "Product implementation changed; context memory must be updated."
  fi

  # Architecture/security/dependency/deployment-impacting changes require ADR.
  if echo "$changed" | grep -E '^(docs/architecture|docs/security|docs/security-requirements.md|\.github/workflows/|package.json|pnpm-lock.yaml|package-lock.json|yarn.lock|docker-compose.yml|infrastructure/)' >/dev/null; then
    echo "$changed" | grep -E '^docs/adrs/ADR-.*\.md$' >/dev/null \
      || fail "Architecture/security/dependency/deployment-impacting change detected; update or add an ADR."
  fi

  # AI/API/billing/usage-heavy changes require unit economics review.
  if echo "$changed" | grep -Ei '(openai|anthropic|ai|llm|stripe|billing|subscription|usage|quota|rate.?limit|token|webhook)' >/dev/null; then
    echo "$changed" | grep -E '^docs/unit-economics.md$' >/dev/null \
      || fail "AI/API/billing/usage-related change detected; docs/unit-economics.md must be updated or reviewed."
  fi

  # Feature requests or product docs require scope control alignment.
  if echo "$changed" | grep -E '^(docs/product/|docs/prd.md|docs/acceptance-criteria.md|\.github/ISSUE_TEMPLATE/feature_request.md)' >/dev/null; then
    echo "$changed" | grep -E '^(docs/scope-control.md|docs/product/mvp-gate.md|docs/acceptance-criteria.md)' >/dev/null \
      || fail "Product/feature change detected; scope-control, MVP Gate or acceptance criteria must be updated."
  fi
fi

pass "Governance enforcement completed."


# Security-sensitive changes require ADR updates.
if [[ -n "${changed:-}" ]]; then
  if echo "$changed" | grep -Ei '(auth|authentication|authorization|middleware|security|permission|role|access)' >/dev/null; then
    echo "$changed" | grep -E '^docs/adrs/ADR-.*\.md$' >/dev/null       || fail "Security-sensitive change detected; update or add an ADR."
  fi
fi


# ADR template quality fields
if [[ -f "docs/adrs/ADR-template.md" ]]; then
  grep -q "Decision Confidence" docs/adrs/ADR-template.md || fail "ADR template missing Decision Confidence."
  grep -q "Evidence Source" docs/adrs/ADR-template.md || fail "ADR template missing Evidence Source."
  grep -q "ADR Quality Checklist" docs/adrs/ADR-template.md || fail "ADR template missing Quality Checklist."
fi

# Freshness metadata presence
for file in docs/project-status.md docs/context/current-state.md docs/context/next-session.md; do
  grep -q "Last Updated:" "$file" || fail "$file missing Last Updated field."
done
