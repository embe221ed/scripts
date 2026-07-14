#!/bin/zsh
#
# display_mode.sh — keep the interdotensional theme in sync with the OS
# light/dark appearance.
#
# All theming work (writing the active theme, regenerating every tool's
# config, and running post-generate hooks such as reloading tmux) is delegated
# to `interdot`. This script only decides the *desired polarity* from the OS
# and asks interdot to match it — it no longer knows or hardcodes any theme
# names, so switching to a different theme pair "just works".
#
# The script prints a small shell snippet on stdout for the caller to eval,
# e.g.  eval "$(/opt/scripts/utils/display_mode.sh)"  — that snippet reloads the
# *caller's* interactive shell so it picks up the new theme. Keep stdout limited
# to eval-able commands; progress and interdot's own diagnostics go to stderr,
# which the caller sees directly.
#
# NOTE: the snippet does not source anything — it `exec zsh`s. Re-sourcing
# ~/.zshrc re-runs the oh-my-zsh plugins, and zsh-autosuggestions and
# fast-syntax-highlighting then re-wrap each other's ZLE widget wrappers on every
# pass (each plugin's guard only recognizes its own wrapper); after ~15 passes
# every keystroke dies with "maximum nested function level reached" (FUNCNEST).
# Re-sourcing only the generated files avoids that, but it forces every generated
# file to stay idempotent forever — an invariant nothing can enforce. A fresh
# process needs neither: everything a flip changes is a FILE, and a new shell
# reads files. This is oh-my-zsh's own documented answer (its FAQ calls
# `source ~/.zshrc` "the common wrong suggestion"); `omz reload` is just
# `exec zsh` plus a compdump delete we don't want (3x slower, themes no
# completions).

set -u

DARWIN=1
INTERDOT_PATH="/opt/tools/interdotensional"

DETERMINE_SYSTEM="${0:A:h}/determine_system.sh"
[ -x "${DETERMINE_SYSTEM}" ] || DETERMINE_SYSTEM="/opt/scripts/utils/determine_system.sh"

# --- helpers -----------------------------------------------------------------

# Emit a raw line for the caller to eval (stdout is a shell script).
emit() { print -r -- "$1"; }

# Emit an `echo -e "<msg>"` so the message is shown when the caller evals us.
emit_echo() { print -r -- "echo -e \"$1\";"; }

# Run interdot against our checkout. Prefer a globally-installed binary,
# otherwise fall back to `uv run` inside the project. Returns 127 if neither
# is available. `-C`/`--directory` make interdot operate on our project no
# matter the current working directory.
#
# Named `run_interdot` (not `interdot`) on purpose: `command -v interdot` below
# must probe for a real external binary, and it would otherwise match this very
# function and always report "found".
run_interdot() {
  if command -v interdot >/dev/null 2>&1; then
    command interdot -C "${INTERDOT_PATH}" "$@"
  elif command -v uv >/dev/null 2>&1; then
    uv run --directory "${INTERDOT_PATH}" interdot "$@"
  else
    return 127
  fi
}

# --- 1. desired polarity, derived from the OS --------------------------------

"${DETERMINE_SYSTEM}"
OS=$?
if [ "${OS}" -eq "${DARWIN}" ]; then
  STYLE=$(defaults read -g AppleInterfaceStyle 2>/dev/null || echo "Light")
else
  STYLE=${DISPLAY_MODE:-Light}
fi

# Match case-insensitively so both macOS ("Dark") and a Linux `DISPLAY_MODE`
# of any casing map correctly; anything that isn't "dark" is treated as light.
if [ "${STYLE:l}" = "dark" ]; then
  DESIRED="dark"
else
  DESIRED="light"
fi

# --- 2. current polarity, straight from interdot -----------------------------

# `interdot list themes` marks the active theme with `*` and tags it with its
# polarity, e.g.  `  * gruvbox-material-dark  [dark, ⇄ gruvbox-material-light]`.
# Grab the polarity of the active line — no theme names hardcoded here.
CURRENT=$(run_interdot --color=never list themes 2>/dev/null \
          | sed -nE 's/^[[:space:]]*\*[^[]*\[([a-z]+).*/\1/p')

if [ -z "${CURRENT}" ]; then
  emit_echo "[!] could not determine the active theme from interdot (is it installed?)"
  exit 1
fi

# --- 3. ask interdot to match the OS -----------------------------------------

if [ "${CURRENT}" != "${DESIRED}" ]; then
  # Polarity mismatch: flip to the active theme's light/dark counterpart.
  # interdot rewrites general.yml, regenerates every config, and runs the
  # general.yml hooks (e.g. reloading tmux) for us.
  if run_interdot toggle >/dev/null; then
    emit_echo "[*] switched to the ${DESIRED} theme"
  else
    emit_echo "[!] interdot toggle failed (the active theme may have no light/dark pair)"
  fi
else
  # Already the right polarity: just make sure the generated configs are fresh.
  # This is a no-op when nothing changed, and hooks only fire on a real change.
  if run_interdot generate >/dev/null; then
    emit_echo "[*] ${DESIRED} theme already active; configs up to date"
  else
    emit_echo "[!] interdot generate failed"
  fi
fi

# --- 4. reload the caller's shell ---------------------------------------------

# Everything a theme flip changes is a file on disk; a fresh shell reads files.
# (tmux's own FZF_DEFAULT_OPTS is pushed by a general.yml hook, not from here:
# anything emitted after the exec would never run, and anything emitted before it
# would push the stale pre-flip value.)
#
# Only SUSPENDED jobs block the reload — exec silently orphans them into
# unreachable stopped processes, and unlike `exit` zsh prints no warning.
# Running background jobs survive exec fine, so they must not block a flip.
#
# `exec zsh` — bare, PATH-resolved. Never spell this with an absolute path: if
# the exec fails, the interactive shell dies outright.
emit_echo "[*] reloading this shell (exec zsh)"
emit 'if [[ -n ${(M)jobstates:#suspended*} ]]; then jobs -l; print -u2 "[!] suspended jobs above — shell NOT reloaded. Finish them, then run: exec zsh"; else exec zsh; fi'

exit 0
