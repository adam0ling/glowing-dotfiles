# Dev Session Cheatsheet

## Starting a Session

```bash
cd <project-dir>
work        # starts (or reattaches to) tmux session named tmux-<dirname>
```

Layout: **left pane (62%)** = nvim · **right pane (38%)** = Copilot agent

---

## Tmux

> Prefix: `Ctrl+a`

| Shortcut | Action |
|----------|--------|
| `Ctrl+a \|` | Split pane vertically |
| `Ctrl+a -` | Split pane horizontally |
| `Alt+←/→/↑/↓` | Move between panes (no prefix) |
| `Ctrl+←/→` | Resize pane left/right |
| `Ctrl+a d` | Detach session (keeps it running) |
| `Ctrl+a s` | List & switch sessions (interactive) |
| `Ctrl+a (` / `)` | Previous / next session |
| `Ctrl+a $` | Rename session |
| `Ctrl+a ,` | Rename window |
| `Ctrl+a c` | New window |
| `Ctrl+a n/p` | Next/prev window |
| Mouse | Click to focus pane, scroll to scroll |

**Copy mode** (`Ctrl+a [` to enter):

| Key | Action |
|-----|--------|
| `v` | Start selection |
| `y` | Copy selection & exit |
| `q` | Exit copy mode |

---

## Nvim — File Navigation

> Leader: `Space`

| Key | Action |
|-----|--------|
| `<leader>e` | Toggle file explorer |
| `<leader>g` | Toggle git status panel |
| `<leader>f` | Fuzzy find files |
| `<leader>s` | Search text in project |
| `<leader>b` | Browse open buffers |
| `<Tab>` / `<S-Tab>` | Cycle open buffers |
| `<leader>x` | Close current buffer |

---

## Nvim — Git

| Key | Action |
|-----|--------|
| `<leader>lg` | Open Lazygit (floating window) |
| `<leader>d` | Toggle full diff view (all changed files) |
| `<leader>h` | Git history for current file |
| `<leader>p` | Preview hunk under cursor |
| `<leader>]` | Next changed hunk |
| `<leader>[` | Prev changed hunk |

---

## Nvim — Editing & Clipboard

| Key | Action |
|-----|--------|
| `Ctrl+s` | Save file (normal + insert mode) |
| `y` / `yy` | Copy selection / line → system clipboard |
| `p` | Paste |
| `u` | Undo |
| `Ctrl+r` | Redo |
| `{` / `}` | Jump to prev / next text block (paragraph) |
| `gg` / `G` | Jump to top / bottom of file |
| `Ctrl+d/u` | Scroll half page down/up |
| `/pattern` | Search in file |
| `n` / `N` | Next / prev search result |
| `gcc` | Toggle comment on line |
| `gc` + motion | Toggle comment on range (e.g. `gc5j`) |

---

## Nvim — Completion

| Key | Action |
|-----|--------|
| _(type to trigger)_ | Autocomplete opens automatically |
| `Tab` / `S-Tab` | Navigate completion list |
| `Enter` | Confirm selection |
| `Ctrl+Space` | Force open completion |
| `Ctrl+e` | Dismiss completion |

---

## Nvim — LSP

| Key | Action |
|-----|--------|
| `K` | Hover docs (also auto-shows on cursor rest) |
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `gr` | Go to references (usages) |

---

## Nvim — Diagnostics

| Key | Action |
|-----|--------|
| `<leader>xx` | Toggle project-wide diagnostics (Trouble) |
| `<leader>xb` | Toggle diagnostics for current buffer |
| `<leader>dd` | Show diagnostic detail (float) |
| `]d` / `[d` | Next / prev diagnostic |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |

---

## Nvim — File Explorer (Neo-tree)

| Key | Action |
|-----|--------|
| `<Tab>` / `<S-Tab>` | Cycle between Files / Buffers / Git tabs (inside neo-tree) |

---

## Nvim — Terminal

| Key | Action |
|-----|--------|
| `<leader>t` | Toggle terminal (bottom panel) |
| `Ctrl+\ Ctrl+n` | Exit terminal mode → normal mode |

---

## Nvim — Windows & Panels

| Key | Action |
|-----|--------|
| `:q` | Close current panel/split |
| `Ctrl+w o` | Close all other splits |
| `Ctrl+w h/l` | Move between splits left/right |
| `Ctrl+w =` | Equalize split sizes |

---

## Lazydocker

Launch with:
```bash
lazydocker
```

| Key | Action |
|-----|--------|
| `←/→` or `h/l` | Switch between panels |
| `↑/↓` or `j/k` | Navigate list |
| `[` / `]` | Switch tabs within a panel |
| `enter` | Drill into container details |
| `e` | Open container's logs |
| `d` | Remove container / image |
| `s` | Stop container |
| `r` | Restart container |
| `u` | Up (start) a stopped container |
| `p` | Pull latest image |
| `ctrl+r` | Restart lazydocker |
| `q` | Quit |

---

## Terminal Tools

| Tool | Usage | What it does |
|------|-------|--------------|
| `z <name>` | `z mcp` | Smart jump to frecent dir (zoxide) |
| `cat <file>` | `cat main.py` | Syntax-highlighted file view (bat) |
| `git diff` | automatic | Beautiful diffs (delta) |
| `fzf` | `Ctrl+R` / `Ctrl+T` | Fuzzy history / file search in shell |
| `btop` | `btop` | System monitor TUI |
| `lazygit` | `lazygit` or `<leader>lg` | Full TUI git client |
