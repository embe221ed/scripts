#!/bin/zsh

DARWIN=1
KITTEN_LIGHT="Catppuccin-Latte"
KITTEN_DARK="Catppuccin-Frappe"

/opt/scripts/utils/determine_system.sh
OS=$?
if [ ${OS} = ${DARWIN} ]; then
  STYLE=$(defaults read -g AppleInterfaceStyle 2>/dev/null || echo "Light")
else
  STYLE=${DISPLAY_MODE}
fi

if [ "${STYLE}" = "Light" ]; then
  kitten theme "${KITTEN_LIGHT}"
else
  kitten theme "${KITTEN_DARK}"
fi

source ~/.zshrc

if tmux ls >/dev/null 2>&1; then
  tmux source-file ~/.tmux.conf
fi
