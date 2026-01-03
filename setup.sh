#!/usr/bin/env bash

INSTALL_DIR="$HOME/.local/share/focus-timer"
BIN_DIR="$HOME/.local/bin"

mkdir -p "$INSTALL_DIR"
mkdir -p "$BIN_DIR"
mkdir -p "$HOME/.config/focus-timer"

cp -r bin lib config "$INSTALL_DIR"

ln -sf "$INSTALL_DIR/bin/focus-timer" "$BIN_DIR/focus-timer"
ln -sf "$INSTALL_DIR/bin/focus-timer-config" "$BIN_DIR/focus-timer-config"

cp "$INSTALL_DIR/config/config.ini" "$HOME/.config/focus-timer/config.ini"

shell_name=$(basename "$SHELL")

case "$shell_name" in
    bash) rc="$HOME/.bashrc" ;;
    zsh) rc="$HOME/.zshrc" ;;
    fish) rc="$HOME/.config/fish/config.fish" ;;
    *) rc="$HOME/.profile" ;;
esac

if ! grep -q "focus-timer" "$rc"; then
    echo 'alias focus-timer="$HOME/.local/bin/focus-timer"' >> "$rc"
    echo 'alias focus-timer-config="$HOME/.local/bin/focus-timer-config"' >> "$rc"
fi

echo "Installation complete. Restart your shell."
