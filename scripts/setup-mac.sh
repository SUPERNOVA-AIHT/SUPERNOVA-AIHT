#!/usr/bin/env bash
#
# setup-mac.sh - Mac Development Environment Setup
# Usage: bash scripts/setup-mac.sh
#
# This script installs and configures a complete macOS development environment.
# It is idempotent - safe to run multiple times.

set -euo pipefail

# --- Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info()    { echo -e "${BLUE}[INFO]${NC} $*"; }
success() { echo -e "${GREEN}[OK]${NC} $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $*"; }
error()   { echo -e "${RED}[ERROR]${NC} $*"; }

# --- Preflight ---
if [[ "$(uname)" != "Darwin" ]]; then
    error "This script is for macOS only."
    exit 1
fi

info "Starting Mac development environment setup..."
echo ""

# ==============================================================================
# 1. Xcode Command Line Tools
# ==============================================================================
info "Checking Xcode Command Line Tools..."
if xcode-select -p &>/dev/null; then
    success "Xcode CLT already installed."
else
    info "Installing Xcode Command Line Tools..."
    xcode-select --install
    echo "Press any key after the installation finishes..."
    read -n 1 -s
fi

# ==============================================================================
# 2. Homebrew
# ==============================================================================
info "Checking Homebrew..."
if command -v brew &>/dev/null; then
    success "Homebrew already installed."
    info "Updating Homebrew..."
    brew update
else
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add brew to PATH for Apple Silicon
    if [[ -f /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
fi

# ==============================================================================
# 3. CLI Tools
# ==============================================================================
info "Installing CLI tools..."

CLI_TOOLS=(
    git
    gh              # GitHub CLI
    wget
    curl
    tree
    jq              # JSON processor
    ripgrep         # Fast search (rg)
    fd              # Fast find
    bat             # Better cat
    eza             # Better ls (successor to exa)
    fzf             # Fuzzy finder
    tldr            # Simplified man pages
    htop            # Process viewer
    neovim          # Editor
    tmux            # Terminal multiplexer
    starship        # Shell prompt
    zoxide          # Smarter cd
    lazygit         # Git TUI
    direnv          # Directory-specific env vars
)

for tool in "${CLI_TOOLS[@]}"; do
    if brew list "$tool" &>/dev/null; then
        success "$tool already installed."
    else
        info "Installing $tool..."
        brew install "$tool"
    fi
done

# ==============================================================================
# 4. Programming Languages & Runtimes
# ==============================================================================
info "Installing programming languages & runtimes..."

LANGUAGES=(
    python@3.12
    node
    go
    rust           # via rustup (handled separately below)
)

for lang in "${LANGUAGES[@]}"; do
    if [[ "$lang" == "rust" ]]; then
        if command -v rustc &>/dev/null; then
            success "Rust already installed."
        else
            info "Installing Rust via rustup..."
            curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
            source "$HOME/.cargo/env"
        fi
    else
        if brew list "$lang" &>/dev/null; then
            success "$lang already installed."
        else
            info "Installing $lang..."
            brew install "$lang"
        fi
    fi
done

# ==============================================================================
# 5. GUI Applications (Casks)
# ==============================================================================
info "Installing applications..."

CASKS=(
    visual-studio-code
    iterm2
    docker
    firefox
    rectangle        # Window management
    raycast          # Spotlight replacement
    obsidian         # Notes
    notion
    slack
    discord
    postman          # API testing
    tableplus        # Database GUI
)

for cask in "${CASKS[@]}"; do
    if brew list --cask "$cask" &>/dev/null; then
        success "$cask already installed."
    else
        info "Installing $cask..."
        brew install --cask "$cask" || warn "Failed to install $cask - skipping."
    fi
done

# ==============================================================================
# 6. Fonts
# ==============================================================================
info "Installing developer fonts..."

brew tap homebrew/cask-fonts 2>/dev/null || true

FONTS=(
    font-fira-code-nerd-font
    font-jetbrains-mono-nerd-font
    font-hack-nerd-font
)

for font in "${FONTS[@]}"; do
    if brew list --cask "$font" &>/dev/null; then
        success "$font already installed."
    else
        info "Installing $font..."
        brew install --cask "$font" || warn "Failed to install $font - skipping."
    fi
done

# ==============================================================================
# 7. Node.js Global Packages
# ==============================================================================
info "Installing global npm packages..."

NPM_PACKAGES=(
    typescript
    ts-node
    eslint
    prettier
    pnpm
    yarn
)

for pkg in "${NPM_PACKAGES[@]}"; do
    if npm list -g "$pkg" &>/dev/null; then
        success "npm: $pkg already installed."
    else
        info "Installing npm: $pkg..."
        npm install -g "$pkg"
    fi
done

# ==============================================================================
# 8. Python Tools
# ==============================================================================
info "Installing Python tools..."

PYTHON_TOOLS=(
    pipx
)

for tool in "${PYTHON_TOOLS[@]}"; do
    if brew list "$tool" &>/dev/null; then
        success "$tool already installed."
    else
        info "Installing $tool..."
        brew install "$tool"
    fi
done

PIPX_TOOLS=(
    ruff          # Python linter/formatter
    httpie        # HTTP client
    poetry        # Dependency management
)

for tool in "${PIPX_TOOLS[@]}"; do
    if pipx list 2>/dev/null | grep -q "$tool"; then
        success "pipx: $tool already installed."
    else
        info "Installing pipx: $tool..."
        pipx install "$tool" || warn "Failed to install $tool via pipx."
    fi
done

# ==============================================================================
# 9. fzf Key Bindings
# ==============================================================================
if [[ -f "$(brew --prefix)/opt/fzf/install" ]]; then
    info "Setting up fzf key bindings..."
    "$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc --no-bash --no-fish
fi

# ==============================================================================
# 10. macOS System Preferences
# ==============================================================================
info "Configuring macOS preferences..."

# Show hidden files in Finder
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show path bar in Finder
defaults write com.apple.finder ShowPathbar -bool true

# Show status bar in Finder
defaults write com.apple.finder ShowStatusBar -bool true

# Disable press-and-hold for keys (enable key repeat)
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Fast key repeat rate
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Show file extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

success "macOS preferences configured. Some changes need a logout/restart."

# ==============================================================================
# Done
# ==============================================================================
echo ""
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  Mac setup complete!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
info "Next steps:"
echo "  1. Copy dotfiles:  bash scripts/install-dotfiles.sh"
echo "  2. Restart your terminal"
echo "  3. Set up Git:     git config --global user.name 'Your Name'"
echo "  4. Auth GitHub:    gh auth login"
echo ""
