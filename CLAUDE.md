# Workshop: Applied Context Engineering: Building Agent Skills

use context7 for searching relevant documentation of the frameworks you are using

## Project structure
- `exercises/<track>/<stage>/`: skeletons with TODOs; stages are `1-build/` and `2-subagents/`, each with its own `.claude/skills/` and `tests/`
- `solutions/<track>/<stage>/`: working solutions, same layout
- `cheatsheet.md`: Quick reference

## Environment
- Claude Code via AWS Bedrock in Conveyor IDE
- Skills go in `.claude/skills/<skill-name>/SKILL.md`
- `context7` MCP server for library docs

## Skill conventions
- YAML frontmatter: name, description, allowed-tools
- Dynamic context: `` !`command` ``
- Arguments: `$ARGUMENTS`, `$0`, `$1`
- Supporting files: `${CLAUDE_SKILL_DIR}/path/to/file`
- Keep under 500 lines

## Helping participants
- One TODO at a time, don't dump the full solution
- Explain *why* each design choice matters
- Skill not triggering? Check `description` first
- Test after each TODO

## Testing
- `tests/` directory per stage folder
- run from the stage folder: `bash tests/test-<skill-name>.sh`
- A working skill: installs clean, triggers correctly, structured output
