#!/usr/bin/env bash
# Checks that the failure-triage skill is complete.
# Run from the 2-subagents folder:  bash tests/test-failure-triage.sh
set -u
SKILL=.claude/skills/failure-triage/SKILL.md
fail=0
ok()  { echo "  ✓ $1"; }
bad() { echo "  ✗ $1"; fail=1; }

[ -f "$SKILL" ] || { echo "✗ $SKILL not found — run this from the 2-subagents folder"; exit 1; }
echo "Checking $SKILL"

grep -q "TODO" "$SKILL" && bad "TODOs remain — work them in order" || ok "no TODOs left"
grep -q "^allowed-tools:.*Agent" "$SKILL" && ok "allowed-tools grants Agent (spawns the subagents)" \
  || bad "allowed-tools should include Agent — that's the tool that launches subagents"
grep -q "^allowed-tools:.*Bash" "$SKILL" && ok "allowed-tools grants Bash (subagents run af)" \
  || bad "allowed-tools should include Bash: the subagents shell out to af"
grep -qi "parallel" "$SKILL" && ok "fans out in parallel (Agent calls in one message)" \
  || bad "spell out that the Agent calls go in a single message so failures run in parallel"
grep -qiE "root.?cause" "$SKILL" && grep -qi "severity" "$SKILL" \
  && ok "subagents return a compact verdict (root cause, severity)" \
  || bad "the subagent prompt should demand a compact verdict: root_cause, evidence, severity — not raw logs"
grep -qiE "nothing.*fail|all green|no fail" "$SKILL" && ok "handles the nothing-is-failing case" \
  || bad "say what happens when NOTHING is failing (report all green, don't fan out)"

echo
if [ "$fail" -ne 0 ]; then echo "Not done yet — fix the ✗ lines above."; exit 1; fi
cat <<'EOF'
Structure complete. The real test is behaviour — in this folder run `claude`, then:

    what's broken?

Done when:
  1. it finds the failing DAG(s) and dispatches one subagent per failure,
     visibly in parallel,
  2. the incident summary ranks failures by severity, with a root cause and a
     suggested fix per DAG, and calls out any shared cause,
  3. your context holds verdicts, not raw logs — the subagents kept those.
EOF
