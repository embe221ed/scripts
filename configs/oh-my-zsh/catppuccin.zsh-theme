# PROMPT="%(?:%{$fg_bold[green]%}%1{➜%} :%{$fg_bold[red]%}%1{➜%} ) %{$fg[cyan]%}%c%{$reset_color%}"
# PROMPT+=' $(git_prompt_info)'
#
# ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
# ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
# ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}%1{✗%}"
# ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

/opt/scripts/utils/determine_system.sh
SYSTEM=$?

if [ "${SYSTEM}" = "1" ]; then
	IS_DARK=$(defaults read -g AppleInterfaceStyle 2>/dev/null || echo "Light")
else
	IS_DARK="Dark"
fi

if [ "${IS_DARK}" = "Dark" ]; then
  cyan="%F{117}" # Approximation of sky (#99d1db)
else
  # Inspired by Latte's sky (approx #04a5e5):
  cyan="%F{39}"
fi

red="%F{203}"      # Approx red (#e78284)
blue="%F{110}"     # Approx blue (#8caaee)
green="%F{149}"    # Approx green (#a6d189)
yellow="%F{179}"   # Approx yellow (#e5c890)
magenta="%F{176}"  # Approx mauve (#ca9ee6)
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
