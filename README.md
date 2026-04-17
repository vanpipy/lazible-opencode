# Lazible OpenCode Config

Portable OpenCode configuration tailored for oh-my-openagent and Superpowers. This setup lets you bootstrap a new machine quickly with a consistent OpenCode + MiniMax + Superpowers environment.

## Dependencies

- Node.js (LTS 18+ recommended)
- Git
- Internet access for fetching plugins
- MiniMax API key exported as `MINIMAX_API_KEY`

## What's Included

- `opencode.json`
  - Configures MiniMax via an Anthropic-compatible API endpoint
  - Installs plugins:
    - Superpowers (via git)
    - oh-my-openagent (pinned to a specific tag)
- `oh-my-openagent.json`
  - Declares available agents (sisyphus, hephaestus, librarian, etc.)
  - Centralizes model routing in categories (quick, ultrabrain, writing, …)
- `package.json`
  - Declares the minimal dependency to load OpenCode plugins
  - Adds a `start` script for convenience

## Quick Setup

```bash
# Clone the config
git clone https://github.com/vanpipy/lazible-opencode.git ~/.config/opencode
cd ~/.config/opencode

# Install dependencies and setup skill symlinks
./install.sh

# Start OpenCode
export MINIMAX_API_KEY="your-api-key"
opencode
```

## Installation Script

The `install.sh` script handles packages that OpenCode cannot fully auto-configure:

```bash
./install.sh              # Full installation (npm + skills symlinks + verify)
./install.sh --skills     # Only setup skill symlinks
./install.sh --verify     # Only verify installation
```

### Why is this needed?

OpenCode's skill tool discovers skills from:
- `~/.config/opencode/skills/` (user global skills)
- `./.opencode/skills/` (project-local skills)

However, some npm packages (like superpowers) install their skills to `node_modules/<package>/skills/`, which OpenCode doesn't auto-discover. The install script creates symlinks to bridge this gap.

Currently handled:
- **superpowers** → skills symlinked to `~/.config/opencode/skills/superpowers`

To add support for another package, edit `install.sh` and add a symlink in `setup_skill_symlinks()`:
```bash
if [ -d "$NODE_MODULES/another-package/skills" ]; then
    ln -sf "$NODE_MODULES/another-package/skills" "$SKILLS_DIR/another-package"
fi
```

## Project Setup (Alternative)

```bash
# Project-local setup instead of global
git clone https://github.com/vanpipy/lazible-opencode.git
cd lazible-opencode
./install.sh
export MINIMAX_API_KEY="your-api-key"
opencode
```

Notes:
- OpenCode picks up `opencode.json` and `oh-my-openagent.json` from the current directory; or from `~/.config/opencode` when run elsewhere.
- Keep your API key in environment variables; avoid committing credentials.

## Using Superpowers

Superpowers provides an extended tool suite (git, fs, skills, etc.) and integrates as an OpenCode plugin. After running `install.sh`, skills are auto-discovered.

Verify by asking OpenCode:
```
use skill tool to list skills
```

You should see: brainstorming, writing-plans, systematic-debugging, etc.

References:
- Superpowers for OpenCode: https://github.com/obra/superpowers

## Using oh-my-openagent

oh-my-openagent supplies specialized agents and categories. This repo binds all categories to `minimax-cn-coding-plan/MiniMax-M2.7` by default via `oh-my-openagent.json`. You can start a session and select agents as needed; the plugin manages per-agent prompts and behaviors internally.

References:
- Configuration reference: https://github.com/code-yeongyu/oh-my-openagent/blob/HEAD/docs/reference/configuration.md

## Recommended Workflow (Specify + Superpowers)

1. Specify
   - Use planning agents to draft an implementation plan with objectives, constraints, acceptance criteria, and file touchpoints.
2. Review
   - Use librarian/oracle to validate assumptions and surface relevant repo context.
3. Apply
   - Switch to the build agent and use Superpowers tools (git/fs/skills) to apply changes safely.
   - Stage, diff, and commit in small logical changes for easy review and rollback.

Skills:
- Global skills: `~/.config/opencode/skills`
- Project skills: `./.opencode/skills`
Place Anthropics-compatible skills here for automatic discovery by Superpowers' skill tools.

## Version Pinning & Upgrades

- Plugins are pinned for reproducibility, for example:
  - `superpowers@git+https://github.com/obra/superpowers.git#v5.0.6`
  - `oh-my-openagent`
  - `@broskees/opencode-codebase-graph`

To update, re-run `install.sh` or manually update package.json and run `npm install && ./install.sh --skills`.

## Troubleshooting

- Skills not found: Run `./install.sh --verify` to check symlinks
- 401 or auth errors: verify `MINIMAX_API_KEY` is exported in the current shell and has sufficient credits
- Plugin fetch failures: ensure Git is installed and the machine can reach GitHub

## License

MIT © Contributors