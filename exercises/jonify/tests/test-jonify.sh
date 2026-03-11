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
check "Description includes trigger" 'grep -qi "use when" exercises/jonify/.claude/skills/jonify/SKILL.md'
check "Uses \$ARGUMENTS" 'grep -q "\$ARGUMENTS\|\$0\|\$1" exercises/jonify/.claude/skills/jonify/SKILL.md'
check "Has inline python script" 'grep -q "python3 -c\|import.*base64\|urllib" exercises/jonify/.claude/skills/jonify/SKILL.md'
check "Has allowed-tools" 'grep -q "allowed-tools:" exercises/jonify/.claude/skills/jonify/SKILL.md'
check "Style samples dir exists" '[ -d exercises/jonify/reference/style-samples ]'
check "Style samples not empty" '[ "$(ls exercises/jonify/reference/style-samples/*.png exercises/jonify/reference/style-samples/*.jpg 2>/dev/null | wc -l)" -gt 0 ]'

echo ""
echo "Results: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ] && echo "All checks passed." || exit 1
