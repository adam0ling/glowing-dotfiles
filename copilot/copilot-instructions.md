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

## Git commits

Prefer atomic, targeted commits — one commit per file or per logical change. Avoid bulk commits that bundle many unrelated files together. This keeps history clean, reviews focused, and rollbacks precise.

Always ask the user for confirmation before starting a series of commits, showing the proposed commit plan (messages and files). Once confirmed, proceed with all atomic commits without interrupting again.

## Ask, don't guess

When the user reports unexpected behaviour and the cause is not immediately
obvious from code already read in the current turn — **ask a clarifying
question before proposing or making any changes**. Never speculate about
root cause and start editing based on that speculation.

## Browser integration

When opening links or URLs for the user, use the `$BROWSER` environment variable:
```bash
"$BROWSER" "https://example.com"
```

`$BROWSER` is set to the Windows Edge browser at `/mnt/c/Program Files (x86)/Microsoft/Edge/Application/msedge.exe`.
