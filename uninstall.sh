#!/usr/bin/env bash

INSTALL_DIR="$HOME/.local/share/focus-timer"
BIN_DIR="$HOME/.local/bin"

rm -rf "$INSTALL_DIR"
rm -f "$BIN_DIR/focus-timer"
rm -f "$BIN_DIR/focus-timer-config"

for rc in "$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.profile" "$HOME/.config/fish/config.fish"; do
    sed -i '/focus-timer/d' "$rc" 2>/dev/null
done

echo "Uninstalled."
