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

echo "Jonify skill checks:"
check "GEMINI_API_KEY is set" '[ -n "${GEMINI_API_KEY:-}" ]'
check "SKILL.md exists" '[ -f exercises/jonify/.claude/skills/jonify/SKILL.md ]'
check "Description is not empty" 'grep -q "^description: \".\+" exercises/jonify/.claude/skills/jonify/SKILL.md'
check "Uses \$ARGUMENTS" 'grep -q "\$ARGUMENTS\|\$0\|\$1" exercises/jonify/.claude/skills/jonify/SKILL.md'
check "References style-guide.md" 'grep -q "style-guide" exercises/jonify/.claude/skills/jonify/SKILL.md'
check "Has allowed-tools" 'grep -q "allowed-tools:" exercises/jonify/.claude/skills/jonify/SKILL.md'

echo ""
echo "Results: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ] && echo "All checks passed." || exit 1
