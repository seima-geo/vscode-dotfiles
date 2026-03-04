#!/bin/bash
set -e # Exit immediately if a command exits with a non-zero status

echo "Starting dotfiles installation..."

# 1. Check if sudo is available
if command -v sudo >/dev/null 2>&1; then
    SUDO="sudo"
else
    SUDO=""
fi

# 2. Install prerequisites (zsh, curl, git, zoxide)
echo "Installing prerequisites..."
$SUDO apt-get update
$SUDO apt-get install -y zsh curl git zoxide

# 3. Install Oh My Zsh (if not already installed)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    # Install in non-interactive mode
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# 4. Download custom plugins
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    echo "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    echo "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting
fi

# 5. Create symlink for .zshrc
# VS Code clones the repository to ~/dotfiles by default
DOTFILES_DIR="$HOME/dotfiles"
if [ -f "$DOTFILES_DIR/.zshrc" ]; then
    echo "Symlinking .zshrc..."
    ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
fi

# 6. Change default shell to zsh
echo "Changing default shell to zsh..."
$SUDO chsh -s $(which zsh) $(whoami)

echo "Dotfiles installation complete! Enjoy your zsh environment."