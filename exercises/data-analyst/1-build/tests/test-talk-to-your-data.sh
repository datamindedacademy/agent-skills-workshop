#!/usr/bin/env bash
# Checks that the talk-to-your-data skill is complete.
# Run from the 1-build folder:  bash tests/test-talk-to-your-data.sh
set -u
SKILL=.claude/skills/talk-to-your-data/SKILL.md
fail=0
ok()  { echo "  ✓ $1"; }
bad() { echo "  ✗ $1"; fail=1; }

[ -f "$SKILL" ] || { echo "✗ $SKILL not found — run this from the 1-build folder"; exit 1; }
echo "Checking $SKILL"

grep -q "TODO" "$SKILL" && bad "TODOs remain — work them in order" || ok "no TODOs left"
grep -q "^allowed-tools:.*Bash" "$SKILL" && ok "allowed-tools grants Bash (needed to run duckdb)" \
  || bad "allowed-tools should include Bash: the skill shells out to duckdb"
grep -q '!`duckdb' "$SKILL" && ok "schema injected as dynamic context (!\`duckdb …\`)" \
  || bad "no !\`duckdb …\` line: the schema section should be injected at invocation time"
grep -q -- "-readonly" "$SKILL" && ok "queries run read-only" || bad "queries must use duckdb -readonly"
grep -q "\.\./\.\./\.\./data/warehouse\.duckdb" "$SKILL" && ok "points at the shared warehouse (../../../data)" \
  || bad "warehouse path should be ../../../data/warehouse.duckdb (3 levels up from this folder)"
grep -qi "caveat" "$SKILL" && ok "output format demands caveats" \
  || bad "output format should require a caveats line — that's what makes answers trustworthy"
grep -qiE "lower\(status\)|casing" "$SKILL" && grep -qiE "outlier|999999" "$SKILL" \
  && ok "data quirks are encoded (status casing, outliers)" \
  || bad "encode the quirks you found: status casing, amount outlier, country variants, future date"

echo
if [ "$fail" -ne 0 ]; then echo "Not done yet — fix the ✗ lines above."; exit 1; fi
cat <<'EOF'
Structure complete. The real test is behaviour — in this folder run `claude` and ask,
WITHOUT naming the skill:

    Which country generates the most revenue?

Done when:
  1. the skill fires on its own (your description triggered it),
  2. the answer shows the SQL it ran and a small result table,
  3. a caveat calls out the quirks that affect the number.
EOF
