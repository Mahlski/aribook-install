#!/usr/bin/env fish

# Claude installers drop binaries in ~/.local/bin; add it to PATH first so
# the curl installer doesn't warn that the directory is missing from PATH.
mkdir -p ~/.local/bin
fish_add_path -g ~/.local/bin

echo "==> Installing claude-desktop-native via yay..."
yay -S --needed --noconfirm claude-desktop-native

echo "==> Installing Claude Code via curl..."
curl -fsSL https://claude.ai/install.sh | bash

echo "==> Done"
