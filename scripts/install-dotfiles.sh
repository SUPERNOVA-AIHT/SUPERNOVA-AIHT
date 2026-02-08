#!/usr/bin/env bash
#
# install-dotfiles.sh - Symlink dotfiles to home directory
# Usage: bash scripts/install-dotfiles.sh
#
# Creates symlinks from ~/.<file> to dotfiles/<file> in this repo.
# Existing files are backed up to ~/dotfiles-backup-<timestamp>/

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")/../dotfiles" && pwd)"
BACKUP_DIR="$HOME/dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info()    { echo -e "${BLUE}[INFO]${NC} $*"; }
success() { echo -e "${GREEN}[OK]${NC} $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $*"; }

FILES=(
    "zshrc:.zshrc"
    "gitconfig:.gitconfig"
    "vimrc:.vimrc"
    "tmux.conf:.tmux.conf"
    "starship.toml:.config/starship.toml"
)

backed_up=false

for entry in "${FILES[@]}"; do
    src="${entry%%:*}"
    dest="${entry##*:}"
    src_path="$DOTFILES_DIR/$src"
    dest_path="$HOME/$dest"

    if [[ ! -f "$src_path" ]]; then
        warn "Source not found: $src_path - skipping."
        continue
    fi

    # Create parent directory if needed (e.g. .config/)
    mkdir -p "$(dirname "$dest_path")"

    # Backup existing file if it's not already a symlink to our file
    if [[ -f "$dest_path" && ! -L "$dest_path" ]]; then
        if [[ "$backed_up" == false ]]; then
            mkdir -p "$BACKUP_DIR"
            backed_up=true
        fi
        info "Backing up $dest_path -> $BACKUP_DIR/"
        cp "$dest_path" "$BACKUP_DIR/"
    fi

    # Remove existing file/symlink
    rm -f "$dest_path"

    # Create symlink
    ln -s "$src_path" "$dest_path"
    success "Linked $dest -> $src_path"
done

echo ""
if [[ "$backed_up" == true ]]; then
    info "Backups saved to: $BACKUP_DIR"
fi
success "Dotfiles installed! Restart your shell or run: source ~/.zshrc"
