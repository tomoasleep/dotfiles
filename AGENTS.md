# AGENTS.md

This repository is a personal dotfiles and tooling collection.
Agents should treat it as a multi-tool mono-repo, not a single app.

## Quick map
- Root scripts live in script/ and setup/
- Provisioning: mitamae/ (preferred) and playbook/ (deprecated Ansible)
- Tools: tools/zellij-bundler (Ruby gem), tools/gh-watch (shell)
- Editor config: config/nvim (Lua), config/zsh (zsh), config/.wezterm.lua (Lua)
- Tests: test/devcontainer_test.rb (Minitest)

## Build, lint, test
### Repository-level
- No global build or lint command is defined.
- Most changes are config updates; run the relevant tool or app manually.
- For provisioning flows, use the mitamae runner.

### Setup / provisioning
- Run the full setup script: `setup` (invokes `mitamae`).
- Direct mitamae run: `cd mitamae && ../bin/mitamae local recipe.rb --shell /bin/bash`
- Deprecated Ansible playbook: `ansible-playbook playbook/setup.yml -K`

### Zellij bundler tool (tools/zellij-bundler)
- Install dependencies: `cd tools/zellij-bundler && bundle install`
- Build gem: `cd tools/zellij-bundler && gem build zellij-bundler.gemspec`
- Install gem locally: `cd tools/zellij-bundler && gem install zellij-bundler-*.gem`
- Run CLI: `cd tools/zellij-bundler && bin/zellij-bundler <command>`

### Tests
- Run all tests: `ruby test/devcontainer_test.rb`
- Run a single test (Minitest name or regex): `ruby test/devcontainer_test.rb -n /pattern/`
- The test spins up Docker and runs `setup`; expect it to be slow.

### Lint / format
- No repo-wide linter or formatter is configured.
- Keep formatting consistent with the touched file.

## Style guide (general)
- Prefer minimal, explicit changes; this is a dotfiles repo.
- Avoid adding new comments; keep code self-explanatory.
- Keep line endings as LF.
- Use 2-space indentation for Ruby, Lua, and shell, matching existing files.
- Sort configuration blocks only when the file already follows a clear ordering.
- When editing config files, preserve existing keys and sections unless the change requires reordering.

## Bash / shell
- Scripts typically start with `#!/bin/bash` and `set -eux`.
- Preserve `set -eux` unless a specific script requires softer error handling.
- Use `[[ ... ]]` for bash conditionals where practical.
- Quote variables unless intentionally relying on word splitting.
- Prefer `$(...)` over backticks.
- Use lowercase, underscore-separated variable names unless a variable is exported.
- Use `exit 1` on failures; surface clear error messages with `echo` or `printf`.
- When running external tools, check their availability in README or scripts before introducing new dependencies.

## Zsh
- Zsh functions and plugin snippets live under `config/zsh/`.
- Keep function names descriptive and avoid collisions with builtins.
- Prefer `local` for function-scoped variables.
- Keep plugin metadata in `config/zsh/pack/package.json` consistent with existing structure.

## Ruby (tools/zellij-bundler, tests)
- Use single quotes for plain strings; use double quotes when interpolation is needed.
- Keep `require` lines at the top: stdlib first, then relative requires.
- Use 2-space indentation and Ruby block style `do ... end` as in existing files.
- Prefer small methods with early returns on error.
- CLI behavior uses `puts` for user-facing output and `exit 1` for failures.
- Exceptions are rescued as `StandardError` with a clear message; avoid swallowing errors silently.
- For JSON/YAML parsing, validate expected keys before use.
- For filesystem changes, check `File.exist?` and use `File.expand_path` when needed.

## Lua (config/nvim, config/.wezterm.lua)
- Use `local` for module-scoped variables.
- Follow existing style: 2-space indentation and single quotes for strings.
- Keep `require` statements at the top of the file.
- Return config tables explicitly when using builder patterns.

## YAML / JSON / TOML / KDL
- Keep indentation and key ordering consistent with the file you touch.
- Prefer trailing newlines.
- Do not reformat large files unless necessary for the change.

## Imports and dependencies
- Avoid introducing new runtime dependencies unless necessary.
- If you add a dependency, update the nearest README or relevant config.
- For Ruby tools, update the gemspec or Gemfile if new gems are required.
- For shell tools, prefer standard utilities already used in the repo.

## Naming conventions
- Ruby: snake_case methods, CamelCase classes/modules, CONSTANTS for constants.
- Shell variables: lower_snake_case locally, UPPER_SNAKE_CASE for exported vars.
- Lua: lower_snake_case for local variables; module tables use lower_snake_case names.
- Files: keep existing naming patterns (e.g., `zellij-bundler`, `zellij-bundles.rb`).

## Error handling
- Shell: fail fast with `set -e`; explicitly handle non-fatal errors with comments avoided.
- Ruby: return early after printing user-friendly errors; use `exit 1`.
- Tests: let Minitest failures bubble; do not rescue in tests.

## Testing guidance (TDD)
- Follow t-wada style TDD when adding or changing behavior.
- Write or update tests first when behavior changes are involved.
- Prefer small, isolated tests and clear failure messages.

## Repo-specific notes
- `mitamae/` is the primary provisioning mechanism.
- `playbook/` is deprecated but still kept for reference.
- `tools/zellij-bundler/` is a standalone Ruby gem.
- `zellij-bundles.rb` and `zellij-bundles-lock.yaml` are root-level configs.
- `config/` holds app configs (nvim, zsh, wezterm, etc.).

## Cursor / Copilot rules
- No `.cursor/rules/`, `.cursorrules`, or `.github/copilot-instructions.md` found.

## When you add new files
- Prefer placing scripts under `script/` or `bin/` depending on usage.
- Keep executable permissions consistent with existing scripts.
- Update READMEs if a new tool or workflow is introduced.

## Suggested validation checklist
- Ran the relevant command or script for the change.
- For provisioning changes, verify with `mitamae` on a test machine or container.
- For tool changes, run the tool's basic command path.
- For Lua config changes, open Neovim or WezTerm to ensure it loads.

## Single-test examples
- Minitest by name: `ruby test/devcontainer_test.rb -n test_can_create_devcontainer`
- Minitest by regex: `ruby test/devcontainer_test.rb -n /devcontainer/`

## Frequently used paths
- `script/setup.sh` and `script/install-local-homebrew.sh`
- `mitamae/recipe.rb`
- `tools/zellij-bundler/`
- `config/nvim/`
- `config/zsh/`
- `config/.wezterm.lua`

## Notes for agents
- This repo is mostly configuration; be conservative in edits.
- Avoid sweeping refactors or formatting-only changes.
- Respect existing conventions in each directory.
- Keep changes localized and easy to review.

## Contact
- Owner: tomoasleep (see repo README).

## End
- Keep this document up to date as workflows evolve.
