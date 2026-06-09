resource "conveyor_project" "workshop" {
  name                       = local.project_name
  default_iam_identity       = aws_iam_role.workshop.name
  description                = "AI Agent Skills for Data Practitioners: hands-on workshop"
  git_repo                   = "https://github.com/datamindedacademy/agent-skills-workshop"
  default_ide_environment_id = conveyor_environment.workshop.id

  default_ide_config {
    vscode_config {
      extensions = [
        "ms-python.python",
        "charliermarsh.ruff@2026.36.0",
        "anthropic.claude-code",
        "chuckjonas.duckdb",
      ]
    }

    build_steps {
      name = "VSCode Settings"
      cmd  = <<-EOT
        mkdir -p "$HOME/.local/share/code-server/Machine"
        cat << 'EOF' > "$HOME/.local/share/code-server/Machine/settings.json"
        {
            "git.openRepositoryInParentFolders": "always",
            "git.requireGitUserConfig": false,
            "python.defaultInterpreterPath": "$HOME/.venv/bin/python"
        }
        EOF
      EOT
    }

    build_steps {
      name = "Install Python and uv"
      cmd  = <<-EOT
        curl -LsSf https://astral.sh/uv/install.sh | sh
        uv python install 3.13
        uv python pin 3.13 --global
      EOT
    }

    build_steps {
      name = "Install virtual env"
      cmd  = <<-EOT
        uv venv $HOME/.venv
        echo "source \$HOME/.venv/bin/activate" >> ~/.bashrc
      EOT
    }

    build_steps {
      name = "Install workshop CLIs (af, checkup, duckdb, jq)"
      cmd  = <<-EOT
        sudo apt-get update && sudo apt-get install -y jq
        uv tool install astro-airflow-mcp
        uv tool install checkup --with checkup-dbt --with dbt-duckdb
        curl https://install.duckdb.org | sh
        echo 'export PATH="$HOME/.duckdb/cli/latest:$PATH"' >> ~/.bashrc
      EOT
    }

    build_steps {
      name = "Install Node.js (for npx skills)"
      cmd  = <<-EOT
        curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
        sudo apt-get install -y nodejs
      EOT
    }

    build_steps {
      name = "Install Google Cloud CLI"
      cmd  = <<-EOT
        curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
        echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list
        sudo apt-get update && sudo apt-get install -y google-cloud-cli
      EOT
    }

    build_steps {
      name = "Setup Claude Code with Bedrock"
      cmd  = <<-EOT
        curl -fsSL https://claude.ai/install.sh | bash

        {
          echo 'export CLAUDE_CODE_USE_BEDROCK=1'
          echo "export ANTHROPIC_MODEL='eu.anthropic.claude-opus-4-8'"
          echo "export ANTHROPIC_SMALL_FAST_MODEL='eu.anthropic.claude-sonnet-4-6'"
          echo 'export CLAUDE_CODE_MAX_OUTPUT_TOKENS=4096'
          echo 'export MAX_THINKING_TOKENS=1024'
        } >> ~/.bashrc
      EOT
    }

    build_steps {
      name = "Install Starship prompt"
      cmd  = <<-EOT
        curl -sS https://starship.rs/install.sh | sh -s -- -y
        mkdir -p ~/.config
        cat > ~/.config/starship.toml << 'TOML_EOF'
        format = "$directory$git_branch$git_status$character"
        TOML_EOF
        echo 'eval "$(starship init bash)"' >> ~/.bashrc
      EOT
    }
  }
}
