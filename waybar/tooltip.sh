#!/usr/bin/env bash
# Shared tooltip drawing for the waybar scripts in this directory, styled after
# btop: section headers, meters, history graphs and process names.
#
# The scripts sourcing this run continuously, keep their history in memory and
# print one line every $INTERVAL seconds, or a single one with --once.

INTERVAL=5
# Tooltip width in cells, which the graphs, meters and headers fill.
WIDTH=49
# Graph height in rows, each holding eight levels of block height.
GRAPH=3
# Line height of the tooltip rows, except for the graphs, which keep their
# rows close together.
LINE=1.2

# Meter colors from low to high load, using the Dracula palette.
GRADIENT=("#50fa7b" "#50fa7b" "#50fa7b" "#50fa7b" "#f1fa8c" "#f1fa8c"
	"#f1fa8c" "#ffb86c" "#ffb86c" "#ff5555")
TRACK="#44475a"
DIM="#6272a4"
ACCENT="#bd93f9"

# Print the gradient color for percentage $1.
color() {
	local i=$(($1 / 10))
	((i > 9)) && i=9
	echo "${GRADIENT[i]}"
}

# Print the waybar class for percentage $1, matching the warning and critical
# states of the built-in modules.
class() {
	if [ "$1" -ge 95 ]; then
		echo critical
	elif [ "$1" -ge 80 ]; then
		echo warning
	fi
}

# Print kibibytes $1 as gigabytes with one decimal.
gigabytes() {
	local tenths=$((($1 * 10 + (1 << 19)) >> 20))
	printf '%d.%d' $((tenths / 10)) $((tenths % 10))
}

# Print kibibytes $1 as gigabytes with one decimal from 1GB and as megabytes
# below.
size() {
	if [ "$1" -ge $((1 << 20)) ]; then
		printf '%sGB' "$(gigabytes "$1")"
	else
		printf '%dMB' $((($1 + 512) >> 10))
	fi
}

# Print a meter of width $2 for percentage $1. Each cell takes the gradient
# color of its position, and the unfilled part shows as a dim track.
meter() {
	local pct=$1 width=$2 eighths i fill col out="" open=""
	local partial=("" "▏" "▎" "▍" "▌" "▋" "▊" "▉")
	((pct > 100)) && pct=100
	eighths=$((pct * width * 8 / 100))
	for ((i = 0; i < width; i++)); do
		fill=$((eighths - i * 8))
		if ((fill >= 8)); then
			col=${GRADIENT[i * 10 / width]}
			[ "$open" = "$col" ] || {
				[ -n "$open" ] && out+="</span>"
				out+="<span color='$col'>" open=$col
			}
			out+="█"
		elif ((fill > 0)); then
			[ -n "$open" ] && out+="</span>"
			out+="<span color='${GRADIENT[i * 10 / width]}' bgcolor='$TRACK'>${partial[fill]}</span>"
			open=""
		else
			[ "$open" = "$TRACK" ] || {
				[ -n "$open" ] && out+="</span>"
				out+="<span color='$TRACK'>" open=$TRACK
			}
			out+="█"
		fi
	done
	[ -n "$open" ] && out+="</span>"
	printf '%s' "$out"
}

# Append percentage $2 to the history array named $1, keeping $WIDTH entries.
record() {
	local -n values=$1
	values+=("$2")
	((${#values[@]} > WIDTH)) && values=("${values[@]:1}")
	return 0
}

# Print the percentages $2... as a graph $GRAPH rows high, oldest first and
# padded on the left while the history fills up. The graph takes color $1, or
# the gradient color of each value if $1 is empty. The reduced line height
# closes the gaps between rows.
graph() {
	local levels=(" " "▁" "▂" "▃" "▄" "▅" "▆" "▇" "█") out="" pct row fill col open i
	local fixed=$1
	shift
	for ((row = GRAPH - 1; row >= 0; row--)); do
		open=""
		for ((i = $#; i < WIDTH; i++)); do out+=" "; done
		for pct; do
			fill=$((pct * GRAPH * 8 / 100 - row * 8))
			((fill < 0)) && fill=0
			((fill > 8)) && fill=8
			col=${fixed:-${GRADIENT[pct >= 90 ? 9 : pct / 10]}}
			[ "$open" = "$col" ] || {
				[ -n "$open" ] && out+="</span>"
				out+="<span color='$col'>" open=$col
			}
			out+=${levels[fill]}
		done
		[ -n "$open" ] && out+="</span>"
		((row > 0)) && out+="\n"
	done
	printf "<span line_height='0.75'>%s</span>" "$out"
}

# Print tooltip $1 with the rows spaced out by $LINE.
spaced() {
	printf "<span line_height='%s'>%s</span>" "$LINE" "$1"
}

# Print a section header with a rule filling the rest of the width.
header() {
	local rule="" i
	for ((i = ${#1} + 1; i < WIDTH; i++)); do rule+="─"; done
	printf "<span color='%s'><b>%s</b></span> <span color='%s'>%s</span>" \
		"$ACCENT" "$1" "$TRACK" "$rule"
}

# Print label $1 dimmed.
label() {
	printf "<span color='%s'>%s</span>" "$DIM" "$1"
}

# Awk functions making text from the system safe for the tooltip. Process names
# and SSIDs may contain anything, so escape drops control characters, which
# include the tab, drops JSON characters and escapes Pango markup. clean also
# shows Nix wrappers as the program they wrap.
# shellcheck disable=SC2034
CLEAN_NAME='function escape(s) {
	gsub(/[[:cntrl:]]/, "", s)
	gsub(/["\\]/, "", s)
	gsub(/&/, "\\&amp;", s); gsub(/</, "\\&lt;", s); gsub(/>/, "\\&gt;", s)
	return s
}
function clean(name) {
	sub(/^\./, "", name); sub(/-wrapped$/, "", name)
	return escape(name)
}'

# Print $1 escaped for the tooltip.
escape() {
	S=$1 awk "$CLEAN_NAME"' BEGIN { print escape(ENVIRON["S"]) }'
}

# Call function $1 after a short first sample and then every $INTERVAL
# seconds, or once if $2 is --once.
run() {
	sleep 1
	"$1"
	[ "${2:-}" = "--once" ] && return
	while true; do
		sleep "$INTERVAL"
		"$1"
	done
}
