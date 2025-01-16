####################################################################################################
# This is a slanted theme created by @embe221ed (https://github.com/embe221ed)
# colors are inspired by catppuccin and tokyonight palettes
####################################################################################################


eggplant="#ff007c"
theme="catppuccin"

SYSTEM=$(source /opt/scripts/utils/determine_system.sh && echo "Darwin" || echo "Linux")
if [ "${SYSTEM}" = "Darwin" ]; then
	IS_DARK=$(defaults read -g AppleInterfaceStyle 2>/dev/null || echo "Light")
else
	IS_DARK="Dark"
fi

if [ "${IS_DARK}" = "Dark" ]; then
	if [ "${theme}" = "catppuccin" ]; then
		subtext0="#f4b8e4"
		surface0="#626880",
		peach="#ef9f76",
		current_bg=$peach
		thm_bg="#737994"
		blue="#70c0fc"
	else
		current_bg="#18ffde"
		subtext0="#ff007c"
		thm_bg="#3b4261"
		blue="#50a0f0"
	fi
else
	if [ "${theme}" = "catppuccin" ]; then
		subtext0="#209fb5"
		surface0="#ccd0da",
		peach="#fe640b",
		current_bg=$peach
		thm_bg="#dce0e8"
		blue="#04a5e5"
	else
		current_bg="#f048e4"
		subtext0="#18ffde"
		thm_bg="#a8aecb"
		blue="#18e0f0"
	fi
fi

thm_fg=$subtext0

TMUX_POWERLINE_SEPARATOR_LEFT_BOLD="◤"
TMUX_POWERLINE_SEPARATOR_LEFT_THIN="◢"
TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD="◢"
TMUX_POWERLINE_SEPARATOR_RIGHT_THIN="◤"
TMUX_POWERLINE_SEPARATOR_THIN=""

TMUX_POWERLINE_DEFAULT_BACKGROUND_COLOR=${TMUX_POWERLINE_DEFAULT_BACKGROUND_COLOR:-$thm_bg}
TMUX_POWERLINE_DEFAULT_FOREGROUND_COLOR=${TMUX_POWERLINE_DEFAULT_FOREGROUND_COLOR:-$thm_fg}

TMUX_POWERLINE_DEFAULT_LEFTSIDE_SEPARATOR=${TMUX_POWERLINE_DEFAULT_LEFTSIDE_SEPARATOR:-$TMUX_POWERLINE_SEPARATOR_RIGHT_THIN}
TMUX_POWERLINE_DEFAULT_RIGHTSIDE_SEPARATOR=${TMUX_POWERLINE_DEFAULT_RIGHTSIDE_SEPARATOR:-$TMUX_POWERLINE_SEPARATOR_LEFT_THIN}

TMUX_POWERLINE_SEG_VCS_BRANCH_GIT_SYMBOL_COLOUR=$thm_bg

# See man tmux.conf for additional formatting options for the status line.
# The `format regular` and `format inverse` functions are provided as conveinences

if [ -z $TMUX_POWERLINE_WINDOW_STATUS_CURRENT ]; then
	TMUX_POWERLINE_WINDOW_STATUS_CURRENT=(
		"#[$(echo "fg=$thm_bg,bg=$current_bg,bold,noitalics,nounderscore")]" \
		"$TMUX_POWERLINE_SEPARATOR_LEFT_BOLD" \
		" #I#{#F,} " \
		"#[$(echo "fg=$surface0,bg=$current_bg,bold,noitalics,nounderscore")]" \
		"$TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD" \
		"#[$(echo "fg=$current_bg,bg=$surface0,bold,noitalics,nounderscore")]" \
		" #W " \
		"#[$(echo "fg=$thm_bg,bg=$surface0,bold,noitalics,nounderscore")]" \
		"$TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD" \
	)
fi

if [ -z $TMUX_POWERLINE_WINDOW_STATUS_STYLE ]; then
	TMUX_POWERLINE_WINDOW_STATUS_STYLE=(
		"$(format regular)"
	)
fi

if [ -z $TMUX_POWERLINE_WINDOW_STATUS_FORMAT ]; then
	TMUX_POWERLINE_WINDOW_STATUS_FORMAT=(
		"#[$(echo "fg=$thm_bg,bg=$subtext0,nobold,noitalics,nounderscore")]" \
		"$TMUX_POWERLINE_SEPARATOR_LEFT_BOLD" \
		" #I#{#F,} " \
		"#[$(echo "fg=$surface0,bg=$subtext0,nobold,noitalics,nounderscore")]" \
		"$TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD" \
		"#[$(echo "fg=$subtext0,bg=$surface0,nobold,noitalics,nounderscore")]" \
		" #W "
		"#[$(echo "fg=$thm_bg,bg=$surface0,nobold,noitalics,nounderscore")]" \
		"$TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD"
	)
fi

# Format: segment_name background_color foreground_color [non_default_separator] [separator_background_color] [separator_foreground_color] [spacing_disable] [separator_disable]
#
# * background_color and foreground_color. Formats:
#   * Named colors (chech man page of tmux for complete list) e.g. black, red, green, yellow, blue, magenta, cyan, white
#   * a hexadecimal RGB string e.g. #ffffff
#   * 'default' for the defalt tmux color.
# * non_default_separator - specify an alternative character for this segment's separator
# * separator_background_color - specify a unique background color for the separator
# * separator_foreground_color - specify a unique foreground color for the separator
# * spacing_disable - remove space on left, right or both sides of the segment:
#   * "left_disable" - disable space on the left
#   * "right_disable" - disable space on the right
#   * "both_disable" - disable spaces on both sides
#   * - any other character/string produces no change to default behavior (eg "none", "X", etc.)
#
# * separator_disable - disables drawing a separator on this segment, very useful for segments
#   with dynamic background colours (eg tmux_mem_cpu_load):
#   * "separator_disable" - disables the separator
#   * - any other character/string produces no change to default behavior
#
# Example segment with separator disabled and right space character disabled:
# "hostname 33 0 {TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD} 33 0 right_disable separator_disable"
#
# Note that although redundant the non_default_separator, separator_background_color and
# separator_foreground_color options must still be specified so that appropriate index
# of options to support the spacing_disable and separator_disable features can be used

if [ -z $TMUX_POWERLINE_LEFT_STATUS_SEGMENTS ]; then
	TMUX_POWERLINE_LEFT_STATUS_SEGMENTS=(
		"hostname $subtext0 $thm_bg"
		"tmux_session_info $thm_bg $thm_fg"
		"vcs_branch $subtext0 $thm_bg"
	)
fi

if [ -z $TMUX_POWERLINE_RIGHT_STATUS_SEGMENTS ]; then
	TMUX_POWERLINE_RIGHT_STATUS_SEGMENTS=(
		"battery $thm_bg $blue"
		"date $subtext0 $thm_bg"
		"time $subtext0 $thm_bg ┊ $thm_fg $thm_bg"
	)
fi
