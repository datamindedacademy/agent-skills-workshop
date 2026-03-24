#!/bin/bash
set -euo pipefail

# WARNING: --dangerously-skip-permissions is ONLY safe in isolated devcontainers.
# NEVER use this flag against real infrastructure or production systems.

RUNS="${1:-3}"
PROJECT_DIR="exercises/benchmark/dbt_project"
TASK=$(cat exercises/benchmark/TASK.md)
RESULTS_DIR="exercises/benchmark/results"

# --- Pre-flight checks ---

if ! command -v claude &> /dev/null; then
    echo "Error: 'claude' CLI not found. Install Claude Code first."
    exit 1
fi

if ! command -v npx &> /dev/null; then
    echo "Error: 'npx' not found. Install Node.js first."
    exit 1
fi

if ! command -v uv &> /dev/null; then
    echo "Error: 'uv' not found. Install uv first."
    exit 1
fi

if [ -n "$(git status --porcelain -- "$PROJECT_DIR/models/")" ]; then
    echo "Error: Working tree is not clean in $PROJECT_DIR/models/."
    echo "Please commit or stash changes before running the benchmark."
    exit 1
fi

mkdir -p "$RESULTS_DIR"

BASELINE_SESSIONS=()
SKILL_SESSIONS=()

echo "=== BASELINE RUNS (no skill) ==="
for i in $(seq 1 "$RUNS"); do
    echo "Baseline run $i/$RUNS..."
    # Capture session ID from claude output
    SESSION_ID=$(claude -p "$TASK" \
        --dangerously-skip-permissions \
        --output-format json 2>/dev/null \
        | python3 -c "import sys,json; print(json.load(sys.stdin).get('session_id',''))" 2>/dev/null || echo "")
    if [ -n "$SESSION_ID" ]; then
        BASELINE_SESSIONS+=("$SESSION_ID")
        echo "  Session: $SESSION_ID"
    else
        echo "  Warning: Could not capture session ID"
    fi
    git checkout -- "$PROJECT_DIR/models/"
    echo "  Run $i complete, changes reverted."
done

echo ""
echo "=== SKILL RUNS ==="
for i in $(seq 1 "$RUNS"); do
    echo "Skill run $i/$RUNS..."
    SESSION_ID=$(claude -p "/dbt-model $TASK" \
        --dangerously-skip-permissions \
        --output-format json 2>/dev/null \
        | python3 -c "import sys,json; print(json.load(sys.stdin).get('session_id',''))" 2>/dev/null || echo "")
    if [ -n "$SESSION_ID" ]; then
        SKILL_SESSIONS+=("$SESSION_ID")
        echo "  Session: $SESSION_ID"
    else
        echo "  Warning: Could not capture session ID"
    fi
    git checkout -- "$PROJECT_DIR/models/"
    echo "  Run $i complete, changes reverted."
done

# Save session IDs for the compare script
echo ""
echo "=== SAVING SESSION IDs ==="
printf "%s\n" "${BASELINE_SESSIONS[@]}" > "$RESULTS_DIR/baseline_sessions.txt"
printf "%s\n" "${SKILL_SESSIONS[@]}" > "$RESULTS_DIR/skill_sessions.txt"
echo "Baseline sessions: ${BASELINE_SESSIONS[*]:-none}"
echo "Skill sessions: ${SKILL_SESSIONS[*]:-none}"

echo ""
echo "=== COMPARISON ==="
python3 exercises/benchmark/scripts/compare.py "$RESULTS_DIR"
