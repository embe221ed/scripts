####################################################################################################
# This is a minimalist theme created by @embe221ed (https://github.com/embe221ed)
# colors are inspired by catppuccin palettes (https://github.com/catppuccin/catppuccin)
####################################################################################################

# COLORS
thm_pink="#f4b8e4"
blue="#7aa2f7"
subtext0="#a5adce"
eggplant="#ff007c"

thm_fg=$subtext0

SYSTEM=$(source /opt/scripts/utils/determine_system.sh)
if [ "${SYSTEM}" == "Darwin" ]; then
	IS_DARK=$(defaults read -g AppleInterfaceStyle 2>/dev/null || echo "Light")
else
	IS_DARK="Dark"
fi

if [ "${IS_DARK}" = "Dark" ]; then
	thm_bg="#3b4261"
else
  thm_bg="#d0d5e3"
fi

TMUX_POWERLINE_SEPARATOR_LEFT_BOLD=""
TMUX_POWERLINE_SEPARATOR_LEFT_THIN="┊"
TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD=""
TMUX_POWERLINE_SEPARATOR_RIGHT_THIN="┊"
TMUX_POWERLINE_SEPARATOR_THIN="∙"

TMUX_POWERLINE_DEFAULT_BACKGROUND_COLOR=${TMUX_POWERLINE_DEFAULT_BACKGROUND_COLOR:-$thm_bg}
TMUX_POWERLINE_DEFAULT_FOREGROUND_COLOR=${TMUX_POWERLINE_DEFAULT_FOREGROUND_COLOR:-$thm_fg}

TMUX_POWERLINE_DEFAULT_LEFTSIDE_SEPARATOR=${TMUX_POWERLINE_DEFAULT_LEFTSIDE_SEPARATOR:-$TMUX_POWERLINE_SEPARATOR_RIGHT_THIN}
TMUX_POWERLINE_DEFAULT_RIGHTSIDE_SEPARATOR=${TMUX_POWERLINE_DEFAULT_RIGHTSIDE_SEPARATOR:-$TMUX_POWERLINE_SEPARATOR_LEFT_THIN}

TMUX_POWERLINE_SEG_VCS_BRANCH_GIT_SYMBOL_COLOUR=$thm_fg

# See man tmux.conf for additional formatting options for the status line.
# The `format regular` and `format inverse` functions are provided as conveinences

if [ -z $TMUX_POWERLINE_WINDOW_STATUS_CURRENT ]; then
	TMUX_POWERLINE_WINDOW_STATUS_CURRENT=(
		"#[$(echo "fg=$thm_pink,bg=$thm_bg,bold,noitalics,nounderscore")]" \
		"[ #W ]"
	)
fi

if [ -z $TMUX_POWERLINE_WINDOW_STATUS_STYLE ]; then
	TMUX_POWERLINE_WINDOW_STATUS_STYLE=(
		"$(format regular)"
	)
fi

if [ -z $TMUX_POWERLINE_WINDOW_STATUS_FORMAT ]; then
	TMUX_POWERLINE_WINDOW_STATUS_FORMAT=(
		"#[$(format regular)]" \
		" #I#{#F,}" \
		"$TMUX_POWERLINE_SEPARATOR_THIN" \
		"#W "
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
		"hostname $thm_bg $eggplant"
		"tmux_session_info $thm_bg $thm_fg"
		"vcs_branch $thm_bg"
		# "ifstat 30 255" \
		#"ifstat_sys 30 255" \
		# "lan_ip $thm_bg $thm_fg ${TMUX_POWERLINE_SEPARATOR_RIGHT_THIN}" \
		# "wan_ip $thm_bg $thm_fg" \
		# "vcs_compare 60 255" \
		#"vcs_staged 64 255" \
		#"vcs_modified 9 255" \
		#"vcs_others 245 0" \
	)
fi

if [ -z $TMUX_POWERLINE_RIGHT_STATUS_SEGMENTS ]; then
	TMUX_POWERLINE_RIGHT_STATUS_SEGMENTS=(
		# "earthquake 3 0" \
		"pwd $thm_bg $thm_fg"
		#"macos_notification_count 29 255" \
		#"mailcount 9 255" \
		# "now_playing $thm_bg $spotify_green" \
		# "cpu 240 136" \
		# "load 237 167" \
		# "tmux_mem_cpu_load 234 136" \
		"battery $thm_bg $blue"
		# "weather 37 255" \
		#"rainbarf 0 ${TMUX_POWERLINE_DEFAULT_FOREGROUND_COLOR}" \
		#"xkb_layout 125 117" \
		# "date_day $thm_bg $eggplant" \
		"date $thm_bg $thm_fg ${TMUX_POWERLINE_SEPARATOR_LEFT_THIN}"
		"time $thm_bg $thm_fg ${TMUX_POWERLINE_SEPARATOR_LEFT_THIN}"
		#"utc_time 235 136 ${TMUX_POWERLINE_SEPARATOR_LEFT_THIN}" \
	)
fi
