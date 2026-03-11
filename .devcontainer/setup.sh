#!/bin/bash
set -euo pipefail

# Install dbt dependencies
cd exercises/benchmark/dbt_project
uv sync
uv run dbt deps --profiles-dir .
cd -

# Configure Claude Code permissions for the workshop
mkdir -p .claude
cat > .claude/settings.json << 'EOF'
{
  "permissions": {
    "allow": [
      "Bash(uv run:*)",
      "Bash(cd exercises/benchmark/dbt_project && uv run:*)"
    ]
  }
}
EOF
