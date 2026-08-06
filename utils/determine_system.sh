#!/bin/bash
#
# determine_system.sh — the one place that answers "which OS is this?".
#
# THREE calling conventions, all supported:
#
#   determine_system.sh --print   ->  prints `uname` on stdout, exit 0   <-- USE THIS
#   determine_system.sh           ->  prints nothing; exit 0=Linux, 1=Darwin,
#                                     2=Windows-ish, 3=unknown            (legacy;
#                                     utils/display_mode.sh:67 still uses it)
#   source determine_system.sh    ->  prints `uname`, then EXITS the calling
#                                     shell. Only ever safe inside `$( … )`;
#                                     at top level it kills your shell.    (legacy)
#
# This file STAYS in embe221ed/scripts, next to display_mode.sh, its only
# in-repo caller (whose `${0:A:h}` sibling probe depends on that adjacency).
# Its two out-of-repo callers — oh-my-zsh/{catppuccin,cyberpunk}.zsh-theme in
# embe221ed/dotfiles — resolve it by NAME, never by path: $DETERMINE_SYSTEM,
# then `command -v determine_system.sh`, then plain `uname`.
#
# That is why --print's output is EXACTLY `uname` and nothing else: the fallback
# has to be byte-identical to the real answer, or a machine with only the
# dotfiles repo silently inverts every light/dark check that depends on this.
# Because they are identical, there is no cross-repo dependency here — only a
# preference for the real script when it happens to be reachable.

UNAME=$(uname)

# Checked FIRST, and it always exits 0, so it can never be mistaken for the
# exit-code convention below.
if [ "${1:-}" = "--print" ] || [ "${1:-}" = "-p" ]; then
    echo "${UNAME}"
    exit 0
fi

# Sourced? BASH_SOURCE[0] is the sourced file while $0 stays the caller's; it is
# unset entirely under zsh, which lands here too. Left byte-compatible with the
# pre-split behaviour so any caller the sweep missed keeps working.
SCRIPT_NAME=$(basename "$0")
CURRENT_FILE=$(basename "${BASH_SOURCE[0]}")

if [[ "${SCRIPT_NAME}" != "${CURRENT_FILE}" ]]; then
    echo "${UNAME}"
    exit 0
fi

case "${UNAME}" in
    Linux)
      exit 0
      ;;
    Darwin)
      exit 1
      ;;
    CYGWIN*|MINGW32*|MSYS*|MINGW*)
      exit 2
      ;;
    *)
      exit 3
      ;;
esac
