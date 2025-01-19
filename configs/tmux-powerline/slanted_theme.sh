####################################################################################################
# This is a slanted theme created by @embe221ed (https://github.com/embe221ed)
# colors are inspired by catppuccin and tokyonight palettes
####################################################################################################


theme="catppuccin"
if [ "${theme}" = "catppuccin" ]; then
	eggplant="#ea76cb"
else
	eggplant="#ff007c"
fi

SYSTEM=$(source /opt/scripts/utils/determine_system.sh && echo "Darwin" || echo "Linux")
if [ "${SYSTEM}" = "Darwin" ]; then
	IS_DARK=$(defaults read -g AppleInterfaceStyle 2>/dev/null || echo "Light")
else
	IS_DARK="${DISPLAY_MODE}"
fi

if [ "${IS_DARK}" = "Dark" ]; then
	if [ "${theme}" = "catppuccin" ]; then
		alt_bg="#f4b8e4"
		tint_bg0="#626880"
		tint_bg1="#949cbb"
		selected="#ef9f76"
		default_bg="#737994"
		blue="#70c0fc"
	else
		selected="#18ffde"
		alt_bg="#ff007c"
		default_bg="#3b4261"
		blue="#50a0f0"
	fi
else
	if [ "${theme}" = "catppuccin" ]; then
		alt_bg="#209fb5"
		tint_bg0="#ccd0da"
		tint_bg1="#9ca0b0"
		selected="#fe640b"
		default_bg="#dce0e8"
		blue="#04a5e5"
	else
		selected="#f048e4"
		alt_bg="#18ffde"
		default_bg="#a8aecb"
		blue="#18e0f0"
	fi
fi

default_fg=$alt_bg

TMUX_POWERLINE_SEPARATOR_LEFT_BOLD="◤"
TMUX_POWERLINE_SEPARATOR_LEFT_THIN="◢"
TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD="◢"
TMUX_POWERLINE_SEPARATOR_RIGHT_THIN="◤"
TMUX_POWERLINE_SEPARATOR_THIN=""

TMUX_POWERLINE_DEFAULT_BACKGROUND_COLOR=${TMUX_POWERLINE_DEFAULT_BACKGROUND_COLOR:-$default_bg}
TMUX_POWERLINE_DEFAULT_FOREGROUND_COLOR=${TMUX_POWERLINE_DEFAULT_FOREGROUND_COLOR:-$default_fg}

TMUX_POWERLINE_DEFAULT_LEFTSIDE_SEPARATOR=${TMUX_POWERLINE_DEFAULT_LEFTSIDE_SEPARATOR:-$TMUX_POWERLINE_SEPARATOR_RIGHT_THIN}
TMUX_POWERLINE_DEFAULT_RIGHTSIDE_SEPARATOR=${TMUX_POWERLINE_DEFAULT_RIGHTSIDE_SEPARATOR:-$TMUX_POWERLINE_SEPARATOR_LEFT_THIN}

TMUX_POWERLINE_SEG_VCS_BRANCH_GIT_SYMBOL_COLOUR=$default_bg

# See man tmux.conf for additional formatting options for the status line.
# The `format regular` and `format inverse` functions are provided as conveinences

if [ -z $TMUX_POWERLINE_WINDOW_STATUS_CURRENT ]; then
	TMUX_POWERLINE_WINDOW_STATUS_CURRENT=(
		"#[$(echo "fg=$default_bg,bg=$selected,bold,noitalics,nounderscore")]" \
		"$TMUX_POWERLINE_SEPARATOR_LEFT_BOLD" \
		" #I#{#F,} " \
		"#[$(echo "fg=$tint_bg0,bg=$selected,bold,noitalics,nounderscore")]" \
		"$TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD" \
		"#[$(echo "fg=$selected,bg=$tint_bg0,bold,noitalics,nounderscore")]" \
		" #W " \
		"#[$(echo "fg=$default_bg,bg=$tint_bg0,bold,noitalics,nounderscore")]" \
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
		"#[$(echo "fg=$default_bg,bg=$tint_bg1,nobold,noitalics,nounderscore")]" \
		"$TMUX_POWERLINE_SEPARATOR_LEFT_BOLD" \
		" #I#{#F,} " \
		"#[$(echo "fg=$tint_bg0,bg=$tint_bg1,nobold,noitalics,nounderscore")]" \
		"$TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD" \
		"#[$(echo "fg=$tint_bg1,bg=$tint_bg0,nobold,noitalics,nounderscore")]" \
		" #W "
		"#[$(echo "fg=$default_bg,bg=$tint_bg0,nobold,noitalics,nounderscore")]" \
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
		"hostname $eggplant $default_bg"
		"tmux_session_info $tint_bg0 $eggplant"
	)
fi

if [ -z $TMUX_POWERLINE_RIGHT_STATUS_SEGMENTS ]; then
	TMUX_POWERLINE_RIGHT_STATUS_SEGMENTS=(
		"vcs_branch $alt_bg $default_bg"
		"battery $default_bg $blue"
		"date $alt_bg $default_bg"
		"time $alt_bg $default_bg ┊ $default_fg $default_bg"
	)
fi
