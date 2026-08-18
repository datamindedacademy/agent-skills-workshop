#!/usr/bin/env bash
# Checks that the airflow-ops skill is complete.
# Run from the 1-build folder:  bash tests/test-airflow-ops.sh
set -u
SKILL=.claude/skills/airflow-ops/SKILL.md
fail=0
ok()  { echo "  ✓ $1"; }
bad() { echo "  ✗ $1"; fail=1; }

[ -f "$SKILL" ] || { echo "✗ $SKILL not found — run this from the 1-build folder"; exit 1; }
echo "Checking $SKILL"

grep -q "TODO" "$SKILL" && bad "TODOs remain — work them in order" || ok "no TODOs left"
grep -q "^allowed-tools:.*Bash" "$SKILL" && ok "allowed-tools grants Bash (runs the af CLI)" \
  || bad "allowed-tools should include Bash: the skill shells out to af"
grep -q "AIRFLOW_API_URL" "$SKILL" && grep -q "AIRFLOW_AUTH_TOKEN" "$SKILL" \
  && ok "connection recipe sets both env vars" \
  || bad "the connection recipe must set AIRFLOW_API_URL and AIRFLOW_AUTH_TOKEN"
grep -q "conveyor auth get" "$SKILL" && ok "token fetched from conveyor auth get" \
  || bad "the token should come from conveyor auth get (it expires — don't paste it)"
grep -qE '^!`.*af ' "$SKILL" && ok "live DAG list injected as dynamic context (!\`… af …\`)" \
  || bad "no !\`… af dags list …\` line: inject the CURRENT DAG list at invocation time"
grep -qi "confirm" "$SKILL" && ok "state-changing commands need confirmation" \
  || bad "write the guardrail: trigger/pause change production — ask the user first"

echo
if [ "$fail" -ne 0 ]; then echo "Not done yet — fix the ✗ lines above."; exit 1; fi
cat <<'EOF'
Structure complete. The real test is behaviour — in this folder run `claude` and ask,
WITHOUT naming the skill:

    Is the pipeline healthy? What was the last run?

Done when:
  1. the skill fires on its own (your description triggered it),
  2. the answer is a small table (DAG | state | last run | result) plus a
     one-sentence verdict and a suggested next step,
  3. asking it to TRIGGER a run makes it ask for your confirmation first.
EOF
