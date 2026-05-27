#!/usr/bin/env bash
set -euo pipefail

DOTFILES="${DOTFILES:-$HOME/.dotfiles}"

link() {
    src="$DOTFILES/$1"
    dst="$HOME/$1"

    mkdir -p "$(dirname "$dst")"

    if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    backup="$dst.backup.$(date +%Y%m%d%H%M%S)"
    echo "Backing up $dst to $backup"
    mv "$dst" "$backup"
    fi

    ln -sfn "$src" "$dst"
    echo "Linked $dst -> $src"
}

link ".zshrc"
link ".gitconfig"
link ".config/nvim/init.lua"

mkdir -p "$HOME/bin"
for file in "$DOTFILES"/bin/*; do
    [ -e "$file" ] || continue
    ln -sfn "$file" "$HOME/bin/$(basename "$file")"
done

echo "Done."