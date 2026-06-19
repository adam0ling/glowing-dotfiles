# glowing-dotfiles

Personal dev environment — Neovim, tmux, Zsh, and terminal tools on Ubuntu.

## Layout

```
dotfiles/
├── bin/          # custom scripts (work)
├── docs/         # cheatsheet.md
├── nvim/         # ~/.config/nvim/
├── shell/        # ~/.zshrc
├── tmux/         # ~/.tmux.conf
└── install.sh    # symlink installer
```

## Install on a new machine

### 1. Install packages

```bash
# Core tools
sudo apt update && sudo apt install -y \
  zsh tmux neovim git curl fzf btop

# eza (better ls)
sudo apt install -y gpg
sudo mkdir -p /etc/apt/keyrings
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
sudo apt update && sudo apt install -y eza

# zoxide (smart cd)
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

# bat (syntax-highlighted cat)
sudo apt install -y bat && mkdir -p ~/.local/bin && ln -sf /usr/bin/batcat ~/.local/bin/bat

# delta (better git diffs)
DELTA_VERSION=$(curl -s https://api.github.com/repos/dandavison/delta/releases/latest | grep tag_name | cut -d'"' -f4)
curl -sL "https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/git-delta_${DELTA_VERSION}_amd64.deb" -o /tmp/delta.deb
sudo dpkg -i /tmp/delta.deb

# lazygit
LAZYGIT_VERSION=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep tag_name | cut -d'"' -f4 | sed 's/v//')
curl -sL "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/lazygit /usr/local/bin/

# lazydocker
curl -sSfL https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash

# oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# set zsh as default shell
chsh -s $(which zsh)
```

### 2. Clone and run the installer

```bash
git clone https://github.com/adam0ling/glowing-dotfiles.git ~/dotfiles
cd ~/dotfiles && bash install.sh
```

The installer symlinks every config file back to its correct location in `$HOME`.
It backs up any existing files before overwriting and is safe to run multiple times.

### 3. Reload your shell

```bash
exec zsh
```

## Usage

See [`docs/cheatsheet.md`](docs/cheatsheet.md) for keybindings and tool usage.
