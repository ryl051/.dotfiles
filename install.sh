#!/bin/bash

# Get the directory where this script is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Define the files we want to symlink (dotfile_in_home : file_in_repo)
declare -A FILES=(
    [".vimrc"]="vimrc"
    [".tmux.conf"]="tmux.conf"
)

echo "Setting up dotfiles symlinks..."

for target in "${!FILES[@]}"; do
    source_file="$DOTFILES_DIR/${FILES[$target]}"
    target_file="$HOME/$target"

    # If a real file or directory exists at the target, back it up
    if [ -e "$target_file" ] && [ ! -L "$target_file" ]; then
        echo "Backing up existing $target to $target_file.bak"
        mv "$target_file" "$target_file.bak"
    fi

    # Create/override the symlink
    echo "Linking $target_file -> $source_file"
    ln -sf "$source_file" "$target_file"
done

echo "Done! Your configurations are now symlinked."
