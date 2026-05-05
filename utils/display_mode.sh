#!/bin/zsh

DARWIN=1
LIGHT_THEME="gruvbox-material-light"
DARK_THEME="gruvbox-material-dark"
INTERDOTENSIONAL_PATH="/opt/tools/interdotensional"

/opt/scripts/utils/determine_system.sh
OS=$?
if [ ${OS} = ${DARWIN} ]; then
  STYLE=$(defaults read -g AppleInterfaceStyle 2>/dev/null || echo "Light")
else
  STYLE=${DISPLAY_MODE}
fi

if [ "${STYLE}" = "Light" ]; then
  SELECTED_THEME="${LIGHT_THEME}"
else
  SELECTED_THEME="${DARK_THEME}"
fi

# Update config/general.yml with the selected theme.
# Assumes the file contains a line like: theme: <value>
CONFIG_FILE="${INTERDOTENSIONAL_PATH}/config/general.yml"
if [ -f "${CONFIG_FILE}" ]; then
  # Use sed to update the theme value in-place.
  sed -i.bak "s/^theme:.*/theme: \"${SELECTED_THEME}\"/" "${CONFIG_FILE}"
else
  # If the file doesn't exist, create it.
  echo "theme: \"${SELECTED_THEME}\"" > "${CONFIG_FILE}"
fi

# Run the Python generator to rebuild configuration files.
PWD=$(pwd)
cd ${INTERDOTENSIONAL_PATH}
python3 generate.py >/dev/null 2>&1 || echo -e "echo -e \"[!] python3 generate.py failed! (did you activate virtualenv?)\";"
cd ${PWD}

if tmux ls >/dev/null 2>&1; then
  tmux source-file ~/.tmux.conf
fi

echo -e "echo -e \"[*] running: source ~/.zshrc\";"
echo -e "source ~/.zshrc;"
# Push the freshly-sourced FZF_DEFAULT_OPTS into tmux's global env so popups pick it up
echo -e "if command -v tmux >/dev/null 2>&1 && tmux ls >/dev/null 2>&1; then tmux setenv -g FZF_DEFAULT_OPTS \"\$FZF_DEFAULT_OPTS\"; fi;"
echo -e "echo \"[*] remember to apply new configs\";"
