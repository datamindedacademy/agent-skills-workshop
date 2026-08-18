#!/usr/bin/env bash
# Checks that the remediate-products skill is complete.
# Run from the 2-subagents folder:  bash tests/test-remediate-products.sh
set -u
SKILL=.claude/skills/remediate-products/SKILL.md
fail=0
ok()  { echo "  ✓ $1"; }
bad() { echo "  ✗ $1"; fail=1; }

[ -f "$SKILL" ] || { echo "✗ $SKILL not found — run this from the 2-subagents folder"; exit 1; }
echo "Checking $SKILL"

grep -q "TODO" "$SKILL" && bad "TODOs remain — work them in order" || ok "no TODOs left"
grep -q "^allowed-tools:.*Agent" "$SKILL" && ok "allowed-tools grants Agent (spawns the subagents)" \
  || bad "allowed-tools should include Agent — that's the tool that launches subagents"
grep -qi "parallel" "$SKILL" && ok "fans out in parallel (one Agent call per check, one message)" \
  || bad "spell out that the Agent calls go in a single message so checks run in parallel"
grep -q "_marts.yml" "$SKILL" && ok "targets the shared schema file (_marts.yml)" \
  || bad "the skill should name the file being fixed: ../../../data/models/marts/_marts.yml"
grep -qiE "not edit|don't write|must NOT|drafts" "$SKILL" && ok "subagents draft, they don't write" \
  || bad "the guardrail is the point: subagents return edits, only YOU write the shared file"
grep -qi "diff" "$SKILL" && ok "shows the diff before applying" \
  || bad "the output format should show the merged diff before applying it"

echo
if [ "$fail" -ne 0 ]; then echo "Not done yet — fix the ✗ lines above."; exit 1; fi
cat <<'EOF'
Structure complete. The real test is behaviour — in this folder run `claude`, then:

    /remediate-products

Done when:
  1. one subagent per failing check runs, visibly in parallel, and each hands
     back a LIST OF EDITS (neither touches _marts.yml itself),
  2. you're shown a single merged diff of _marts.yml before it's applied,
  3. re-running checkup afterwards shows the flagged metrics moved.
EOF
