#!/usr/bin/env bash
# Run a Lynis audit and save a sanitized copy of the results for docs/lynis/.
#
# Run this on a FRESH AuricOS installation (not the live session):
#   sudo bash lynis-capture.sh round-4
#
# Output: ./lynis-<label>/ containing
#   lynis-output.txt   console output of the audit
#   lynis-report.dat   machine-readable report
#   summary.md         index, test count, warnings and suggestions
#
# A custom hostname, the username, IP addresses and MAC addresses are
# replaced with placeholders, and network-identifying report lines are
# removed, so the files are safe to commit to a public repository.

set -euo pipefail

usage() { echo "Usage: sudo bash $0 <label>   (for example: round-4)"; }

[ $# -eq 1 ] || { usage; exit 2; }
[ "$EUID" -eq 0 ] || { echo "error: run with sudo; Lynis needs root for a full audit" >&2; exit 2; }
command -v lynis >/dev/null || { echo "error: lynis is not installed" >&2; exit 2; }

LABEL=$1
case $LABEL in *[!A-Za-z0-9._-]*) echo "error: label may only contain letters, digits, . _ -" >&2; exit 2 ;; esac

OUT="lynis-$LABEL"
[ -e "$OUT" ] && { echo "error: $OUT already exists" >&2; exit 2; }
mkdir -p "$OUT"

HOST=$(hostname)
USERNAME=${SUDO_USER:-}

sanitize() {
    local args=(
        -e '/^network_ipv[46]_address\[\]=/d'
        -e '/^network_mac_address\[\]=/d'
        -e '/^network_interface\[\]=/d'
        -e 's/\b([0-9]{1,3}\.){3}[0-9]{1,3}\b/<ip>/g'
        -e 's/\b([0-9a-fA-F]{2}:){5}[0-9a-fA-F]{2}\b/<mac>/g'
    )
    # The default hostname "auricos" is not identifying, and replacing it
    # would also rewrite file names such as auricos-blacklist.conf.
    [ "$HOST" != "auricos" ] && args+=(-e "s/\\b${HOST}\\b/<hostname>/g")
    [ -n "$USERNAME" ] && args+=(-e "s/\\b${USERNAME}\\b/<user>/g")
    sed -E "${args[@]}"
}

echo "Running Lynis (this takes a few minutes)..."
lynis audit system --quick --no-colors 2>&1 | sanitize > "$OUT/lynis-output.txt"
sanitize < /var/log/lynis-report.dat > "$OUT/lynis-report.dat"

field() { grep -m1 "^$1=" "$OUT/lynis-report.dat" | cut -d= -f2-; }
INDEX=$(field hardening_index)
TESTS=$(field lynis_tests_done)
VERSION=$(field lynis_version)
WARNINGS=$(grep -c '^warning\[\]=' "$OUT/lynis-report.dat" || true)
SUGGESTIONS=$(grep -c '^suggestion\[\]=' "$OUT/lynis-report.dat" || true)

# Report lines look like: suggestion[]=TEST-ID|Text|details|solution|
list() {
    grep "^$1\[\]=" "$OUT/lynis-report.dat" | cut -d= -f2- \
        | awk -F'|' '{ printf "| %s | %s |\n", $1, $2 }'
}

{
    echo "# Lynis Results: $LABEL"
    echo
    echo "| | |"
    echo "|---|---|"
    echo "| Date | $(date -u +%Y-%m-%d) |"
    echo "| Lynis version | $VERSION |"
    echo "| Kernel | $(uname -r) |"
    echo "| Hardening index | **$INDEX** |"
    echo "| Tests run | $TESTS |"
    echo "| Warnings | $WARNINGS |"
    echo "| Suggestions | $SUGGESTIONS |"
    echo
    echo "## Warnings"
    echo
    if [ "$WARNINGS" -gt 0 ]; then echo "| Test | Warning |"; echo "|---|---|"; list warning; else echo "None."; fi
    echo
    echo "## Suggestions"
    echo
    if [ "$SUGGESTIONS" -gt 0 ]; then echo "| Test | Suggestion |"; echo "|---|---|"; list suggestion; else echo "None."; fi
} > "$OUT/summary.md"

[ -n "$USERNAME" ] && chown -R "$USERNAME": "$OUT" 2>/dev/null || true

echo
echo "Hardening index: $INDEX   Tests: $TESTS   Warnings: $WARNINGS   Suggestions: $SUGGESTIONS"
echo "Saved to $(realpath "$OUT")/"
echo "Review the files before committing them, then copy the folder to docs/lynis/$LABEL/."
