#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="/tmp/pr-review-test-$$"

echo "Creating test repo at $REPO_DIR..."

mkdir -p "$REPO_DIR"
cd "$REPO_DIR"
git init -q
git commit --allow-empty -m "initial" -q

cp "$SCRIPT_DIR/sample-changes/app.py" .
cp "$SCRIPT_DIR/sample-changes/utils.py" .
git add app.py utils.py

echo ""
echo "Done. Test repo ready at: $REPO_DIR"
echo ""
echo "Next steps:"
echo "  cd $REPO_DIR"
echo "  # Copy your SKILL.md into .claude/skills/pr-review/SKILL.md"
echo "  # Then invoke: /pr-review"
echo ""
echo "The staged changes have intentional bugs. Your skill should find them."
