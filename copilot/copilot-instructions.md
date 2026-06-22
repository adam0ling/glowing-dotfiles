# Copilot CLI Global Instructions

## Editor integration (nvim + nvr)

The user runs Copilot CLI in a tmux pane alongside Neovim. A `nvr` script is
available that opens files in the active Neovim instance for the current tmux session.

**When opening files for the user, always use `nvr <path>` instead of printing
the path or suggesting they open it manually.**

Each tmux session has its own Neovim socket at `/tmp/nvim-<session-name>.sock`.
The `nv` shell function (defined in `.zshrc`) launches Neovim registered to that
socket. If `nvr` reports no server, the user needs to restart Neovim with `nv`.

Examples:
- Open a file: `nvr src/app.ts`
- Open multiple files: `nvr src/app.ts src/utils.ts`
