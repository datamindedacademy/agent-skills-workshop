data "conveyor_team" "all_dataminded" {
  name = "all-dataminded"
}

resource "conveyor_project_team" "all_dataminded" {
  project_id = conveyor_project.hackathon.id
  team_id    = data.conveyor_team.all_dataminded.id
  role       = "contributor"
}

resource "conveyor_environment_team" "all_dataminded" {
  environment_id = conveyor_environment.hackandbeers.id
  team_id        = data.conveyor_team.all_dataminded.id
  role           = "contributor"
}

resource "conveyor_project" "hackathon" {
  name                       = local.project_name
  default_iam_identity       = aws_iam_role.hackathon.name
  description                = "Hack and Beers: Applied Context Engineering — Building Agent Skills"
  git_repo                   = "https://github.com/datamindedbe/playground-agent-skills-workshop"
  default_ide_environment_id = conveyor_environment.hackandbeers.id

  default_ide_config {
    vscode_config {
      extensions = [
        "ms-python.python",
        "charliermarsh.ruff@2026.36.0",
        "anthropic.claude-code",
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

        cat >> ~/.bashrc << 'BASHRC_EOF'
        export CLAUDE_CODE_USE_BEDROCK=1
        export ANTHROPIC_MODEL='eu.anthropic.claude-opus-4-6-v1'
        export ANTHROPIC_SMALL_FAST_MODEL='eu.anthropic.claude-haiku-4-5-20251001-v1:0'
        export CLAUDE_CODE_MAX_OUTPUT_TOKENS=4096
        export MAX_THINKING_TOKENS=1024
        BASHRC_EOF
      EOT
    }

    build_steps {
      name = "Inject Gemini API key"
      cmd  = <<-EOT
        GEMINI_API_KEY=$(aws secretsmanager get-secret-value \
          --secret-id ${aws_secretsmanager_secret.gemini_api_key.name} \
          --query SecretString --output text \
          --region ${var.aws_region})
        echo "export GEMINI_API_KEY='$GEMINI_API_KEY'" >> ~/.bashrc
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
