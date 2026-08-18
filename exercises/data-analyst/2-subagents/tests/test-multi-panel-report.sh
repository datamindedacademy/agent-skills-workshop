#!/usr/bin/env bash
# Checks that the multi-panel-report skill is complete.
# Run from the 2-subagents folder:  bash tests/test-multi-panel-report.sh
set -u
SKILL=.claude/skills/multi-panel-report/SKILL.md
fail=0
ok()  { echo "  ✓ $1"; }
bad() { echo "  ✗ $1"; fail=1; }

[ -f "$SKILL" ] || { echo "✗ $SKILL not found — run this from the 2-subagents folder"; exit 1; }
echo "Checking $SKILL"

grep -q "TODO" "$SKILL" && bad "TODOs remain — work them in order" || ok "no TODOs left"
grep -q "^allowed-tools:.*Agent" "$SKILL" && ok "allowed-tools grants Agent (spawns the subagents)" \
  || bad "allowed-tools should include Agent — that's the tool that launches subagents"
grep -q "^allowed-tools:.*Bash" "$SKILL" && ok "allowed-tools grants Bash (subagents run duckdb)" \
  || bad "allowed-tools should include Bash: the subagents shell out to duckdb"
grep -qi "parallel" "$SKILL" && ok "fans out in parallel (Agent calls in one message)" \
  || bad "spell out that the Agent calls go in a single message so sections run in parallel"
grep -qiE "read.?only" "$SKILL" && ok "subagents query read-only" || bad "subagent prompt must demand read-only queries"
grep -q "\.\./\.\./\.\./data/warehouse\.duckdb" "$SKILL" && ok "points at the shared warehouse (../../../data)" \
  || bad "warehouse path should be ../../../data/warehouse.duckdb (3 levels up from this folder)"

echo
if [ "$fail" -ne 0 ]; then echo "Not done yet — fix the ✗ lines above."; exit 1; fi
cat <<'EOF'
Structure complete. The real test is behaviour — in this folder run `claude`, then:

    /multi-panel-report

Done when:
  1. you see the section subagents running AT THE SAME TIME (not one after another),
  2. the report has all three panels plus a 3-bullet executive summary that
     connects findings ACROSS sections,
  3. one merged data-caveats line sits at the bottom.
And the counter-test: ask a single question ("how many customers?") — that
should NOT fan out; it's a one-query answer.
EOF
