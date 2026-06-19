#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d_%H%M%S)"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

info()   { echo -e "${CYAN}[dotfiles]${NC} $*"; }
ok()     { echo -e "${GREEN}[dotfiles]${NC} $*"; }
warn()   { echo -e "${YELLOW}[dotfiles]${NC} $*"; }

backup_and_link() {
  local src="$1"   # absolute path to file inside dotfiles/
  local dest="$2"  # target path in $HOME

  mkdir -p "$(dirname "$dest")"

  # Already the correct symlink — nothing to do
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    ok "Already linked: $dest"
    return
  fi

  # Existing file/dir/broken-link — back it up
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    mkdir -p "$BACKUP_DIR"
    warn "Backing up existing $dest → $BACKUP_DIR/"
    mv "$dest" "$BACKUP_DIR/"
  fi

  ln -s "$src" "$dest"
  ok "Linked: $dest → $src"
}

info "Installing dotfiles from $DOTFILES_DIR"
echo ""

# ── tmux ──────────────────────────────────────────────────────────────────────
backup_and_link "$DOTFILES_DIR/tmux/.tmux.conf"           "$HOME/.tmux.conf"

# ── zsh ───────────────────────────────────────────────────────────────────────
backup_and_link "$DOTFILES_DIR/shell/.zshrc"              "$HOME/.zshrc"

# ── neovim ────────────────────────────────────────────────────────────────────
backup_and_link "$DOTFILES_DIR/nvim/.config/nvim"         "$HOME/.config/nvim"

# ── work script ───────────────────────────────────────────────────────────────
mkdir -p "$HOME/.local/bin"
backup_and_link "$DOTFILES_DIR/bin/work"                  "$HOME/.local/bin/work"
chmod +x "$DOTFILES_DIR/bin/work"

echo ""
ok "All done! Symlinks are in place."

# Remind about PATH if needed
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
  warn "\$HOME/.local/bin is not in your PATH. Add it to your shell config."
fi
