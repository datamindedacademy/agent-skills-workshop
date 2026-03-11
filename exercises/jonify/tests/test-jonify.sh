#!/usr/bin/env bash
set -euo pipefail

PASS=0
FAIL=0

check() {
    if eval "$2" &>/dev/null; then
        echo "  PASS: $1"
        ((PASS++))
    else
        echo "  FAIL: $1"
        ((FAIL++))
    fi
}

SKILL="exercises/jonify/.claude/skills/jonify/SKILL.md"
SAMPLES="exercises/jonify/.claude/skills/jonify/reference/style-samples"

echo "Jonify skill checks:"
check "GEMINI_API_KEY is set" '[ -n "${GEMINI_API_KEY:-}" ]'
check "SKILL.md exists" "[ -f $SKILL ]"
check "Description is not empty" "grep -q '^description: \".\+' $SKILL"
check "Description includes trigger" "grep -qi 'use when' $SKILL"
check "Uses \$ARGUMENTS" "grep -q '\$ARGUMENTS' $SKILL"
check "Has inline python script" "grep -q 'python3 -c' $SKILL"
check "Has allowed-tools" "grep -q 'allowed-tools:' $SKILL"
check "Style samples dir exists" "[ -d $SAMPLES ]"
check "Has style samples" '[ "$(find '"$SAMPLES"' -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.webp" 2>/dev/null | wc -l)" -gt 0 ]'

echo ""
echo "Results: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ] && echo "All checks passed." || exit 1
