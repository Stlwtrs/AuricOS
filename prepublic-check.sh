#!/usr/bin/env bash
# Pre-publication check for the AuricOS repository.
# Scans the working tree AND full git history for personal data and
# checks that required project files exist.
#
# Usage: bash scripts/prepublic-check.sh [extra-term ...]
#   Extra terms (for example your first name) are searched case-insensitively.

set -u
cd "$(git rev-parse --show-toplevel)" || exit 1

FAIL=0
pass() { printf '  \033[32mPASS\033[0m %s\n' "$1"; }
warn() { printf '  \033[33mWARN\033[0m %s\n' "$1"; }
fail() { printf '  \033[31mFAIL\033[0m %s\n' "$1"; FAIL=1; }

ME=$(whoami)
TERMS=("/home/" "$@")
[ "$ME" != "root" ] && TERMS+=("$ME")
PATTERN=$(IFS='|'; echo "${TERMS[*]}")

echo "== Personal data in current files"
HITS=$(git grep -I -n -i -E "$PATTERN" -- . ':!scripts/prepublic-check.sh' || true)
if [ -n "$HITS" ]; then fail "matches found:"; echo "$HITS" | head -20; else pass "no matches"; fi

echo "== Personal data in git history"
HIST=$(git log -p --all -- . ':!scripts/prepublic-check.sh' | grep -n -i -E "^[+-].*($PATTERN)" | head -20 || true)
if [ -n "$HIST" ]; then fail "matches found in history (rewriting history may be needed):"; echo "$HIST"; else pass "no matches"; fi

echo "== Secrets in git history"
SECRETS=$(git log -p --all -- . ':!scripts/prepublic-check.sh' | grep -n -E "BEGIN (RSA|OPENSSH|EC|PGP) PRIVATE KEY|ghp_[A-Za-z0-9]{20,}|github_pat_|AKIA[0-9A-Z]{16}" | head -5 || true)
if [ -n "$SECRETS" ]; then fail "possible secrets:"; echo "$SECRETS"; else pass "no private keys or tokens"; fi

echo "== Commit author identities"
git log --all --format='%an <%ae>' | sort -u | while read -r id; do
  case "$id" in
    *noreply.github.com*) pass "$id" ;;
    *) warn "$id (not a GitHub noreply address)" ;;
  esac
done

echo "== Build artifacts tracked by git"
BIG=$(git ls-files | grep -E '\.(iso|qcow2|img|pkg\.tar\.zst)$|^(work|out)/' || true)
if [ -n "$BIG" ]; then fail "$BIG"; else pass "none"; fi

echo "== Large files (over 5 MB)"
LARGE=$(git ls-files -z | xargs -0 du -k 2>/dev/null | awk '$1 > 5120 {print $2 " (" int($1/1024) " MB)"}')
if [ -n "$LARGE" ]; then warn "$LARGE"; else pass "none"; fi

echo "== Required project files"
for f in README.md LICENSE SECURITY.md CONTRIBUTING.md CHANGELOG.md .gitignore docs/logo.png; do
  if [ -e "$f" ]; then pass "$f"; else fail "$f missing"; fi
done

echo "== Placeholders left to fill"
PH=$(git grep -n -E "YOUR_[A-Z_]+" -- . ':!scripts/prepublic-check.sh' ':!.github/FUNDING.yml' || true)
if [ -n "$PH" ]; then warn "placeholders remain:"; echo "$PH"; else pass "none"; fi

echo "== Screenshot files referenced by README"
for s in $(grep -o 'docs/screenshots/[a-z]*\.png' README.md | sort -u); do
  if [ -e "$s" ]; then pass "$s"; else warn "$s missing"; fi
done

echo
if [ "$FAIL" -eq 0 ]; then echo "No blocking problems found. Review any warnings before going public."
else echo "Fix the FAIL items before making the repository public."; fi
exit "$FAIL"
