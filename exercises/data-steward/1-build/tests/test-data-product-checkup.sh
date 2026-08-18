#!/usr/bin/env bash
# Checks that the data-product-checkup skill is complete.
# Run from the 1-build folder:  bash tests/test-data-product-checkup.sh
set -u
SKILL=.claude/skills/data-product-checkup/SKILL.md
fail=0
ok()  { echo "  ✓ $1"; }
bad() { echo "  ✗ $1"; fail=1; }

[ -f "$SKILL" ] || { echo "✗ $SKILL not found — run this from the 1-build folder"; exit 1; }
echo "Checking $SKILL and checkup.yaml"

grep -q "TODO" "$SKILL" && bad "TODOs remain in SKILL.md — work them in order" || ok "no TODOs left in SKILL.md"
grep -q "^allowed-tools:.*Bash" "$SKILL" && ok "allowed-tools grants Bash (runs checkup)" \
  || bad "allowed-tools should include Bash: the skill shells out to checkup"
grep -qiE "grade|A.F|scorecard" "$SKILL" && ok "output format demands a graded scorecard" \
  || bad "the output format should require an overall grade and a metric table"
grep -qiE "gap|priorit" "$SKILL" && ok "output format ranks the gaps to fix" \
  || bad "the output format should require a prioritized list of gaps, most impactful first"

metrics=$(grep -cE '^\s*- type:' checkup.yaml 2>/dev/null || echo 0)
if [ "$metrics" -ge 3 ]; then ok "checkup.yaml scores $metrics metrics"
else bad "checkup.yaml has only $metrics active metric(s) — add coverage/documentation metrics (see: checkup schema)"; fi

if command -v checkup >/dev/null 2>&1; then
  if checkup run -c checkup.yaml >/dev/null 2>&1; then ok "checkup run -c checkup.yaml succeeds"
  else bad "checkup run -c checkup.yaml fails — run it yourself to see why"; fi
else
  echo "  - checkup not on PATH, skipping live run (in the IDE it's pre-installed)"
fi

echo
if [ "$fail" -ne 0 ]; then echo "Not done yet — fix the ✗ lines above."; exit 1; fi
cat <<'EOF'
Structure complete. The real test is behaviour — in this folder run `claude` and ask,
WITHOUT naming the skill:

    How healthy is our warehouse data product?

Done when:
  1. the skill fires on its own (your description triggered it),
  2. you get one summary line with an overall grade, a metric table with
     ✅/⚠️/❌ statuses,
  3. the biggest gaps are listed first — a scorecard you could act on.
EOF
