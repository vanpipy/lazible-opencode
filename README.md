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

## Setup

```bash
# Global (machine-wide) setup
rm -rf ~/.config/opencode            # optional reset
git clone https://github.com/vanpipy/lazible-opencode.git ~/.config/opencode
cd ~/.config/opencode
npm install
export MINIMAX_API_KEY="YOUR_MINIMAX_API_KEY"
opencode

# Project-local setup
git clone https://github.com/vanpipy/lazible-opencode.git
cd lazible-opencode
npm install
export MINIMAX_API_KEY="YOUR_MINIMAX_API_KEY"
opencode
```

Notes:
- OpenCode picks up `opencode.json` and `oh-my-openagent.json` from the current directory; or from `~/.config/opencode` when run elsewhere.
- Keep your API key in environment variables; avoid committing credentials.

## Using Superpowers

Superpowers provides an extended tool suite (git, fs, skills, etc.) and integrates as an OpenCode plugin. No extra configuration is required if you don't enable a tools whitelist. If you use a whitelist, ensure the corresponding tool IDs from Superpowers are allowed.

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

## Troubleshooting

- Load your superpowers skills [superpowers](https://github.com/obra/superpowers/blob/main/docs/README.opencode.md) via "use skill tool to list skills" in the opencode.
- Install your oh-my-openagent via "npx oh-my-openagent install"
- 401 or auth errors: verify `MINIMAX_API_KEY` is exported in the current shell and has sufficient credits.
- Plugin fetch failures: ensure Git is installed and the machine can reach GitHub.

## License

MIT © Contributors
