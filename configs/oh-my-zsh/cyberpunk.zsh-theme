# PROMPT="%(?:%{$fg_bold[green]%}%1{➜%} :%{$fg_bold[red]%}%1{➜%} ) %{$fg[cyan]%}%c%{$reset_color%}"
# PROMPT+=' $(git_prompt_info)'
#
# ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
# ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
# ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}%1{✗%}"
# ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

# --- which OS? ---------------------------------------------------------------
# determine_system.sh is resolved by NAME, never by path: $DETERMINE_SYSTEM
# wins, then $PATH. The script itself lives in embe221ed/scripts (utils/), which
# this repository does not depend on: `uname` is the floor, and it is exactly
# what --print echoes, so a machine with no scripts checkout — or a stale one —
# degrades to the same answer instead of silently inverting the light/dark
# branch below on the machine you are not sitting at.
_ds="${DETERMINE_SYSTEM:-}"
if [ -z "${_ds}" ]; then _ds="$(command -v determine_system.sh 2>/dev/null)" || _ds=""; fi
SYSTEM=""
if [ -x "${_ds}" ]; then SYSTEM="$("${_ds}" --print 2>/dev/null)" || SYSTEM=""; fi
if [ -z "${SYSTEM}" ]; then SYSTEM="$(uname)"; fi
unset _ds

if [ "${SYSTEM}" = "Darwin" ]; then
	IS_DARK=$(defaults read -g AppleInterfaceStyle 2>/dev/null || echo "Light")
else
	IS_DARK="Dark"
fi

if [ "${IS_DARK}" = "Dark" ]; then
  cyan="%F{51}"
else
  cyan="%F{38}"
fi

red="%F{196}"
blue="%F{75}"
green="%F{40}"
yellow="%F{214}"
magenta="%F{198}"
reset="%f%k%F{default}%K{default}%b%u"

PROMPT='$(virtualenv_prompt_info)'
PROMPT+="%(?:%{$green%}:%{$red%})%B%1{➜%}  %{$cyan%}%c%{$reset%}"
PROMPT+=' $(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%B%{$blue%}git:(%{$magenta%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$blue%}) %{$yellow%}%1{✗%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$blue%})"

ZSH_THEME_VIRTUALENV_PREFIX="%{$yellow%}‹%{$blue%}"
ZSH_THEME_VIRTUALENV_SUFFIX="%{$yellow%}› %{$reset%}"
