#!/usr/bin/env bash
# Shared hwmon helpers, sourced by the waybar scripts in this directory.
#
# These run every few seconds, so they avoid subprocesses: sysfs files are read
# with the read builtin instead of cat, and directories are derived with
# parameter expansion instead of dirname.

# Print the sysfs directory of the first hwmon whose name matches $1 and which
# provides file $2 (optional). This tells apart devices sharing a name, such as
# the discrete and integrated amdgpu, where only the discrete one has a fan.
find_hwmon() {
	local name=$1 required=${2:-name} f dir value
	for f in "${HWMON_ROOT:-/sys/class/hwmon}"/hwmon*/name; do
		dir=${f%/name} value=""
		# read returns non-zero on a file without a trailing newline, which
		# still leaves the value in place.
		IFS= read -r value <"$f" 2>/dev/null || [ -n "$value" ] || continue
		if [ "$value" = "$name" ] && [ -e "$dir/$required" ]; then
			echo "$dir"
			return 0
		fi
	done
	return 1
}

# Print an unsigned sensor value, optionally divided by $2, or nothing when
# missing or unreadable. A real zero remains distinguishable from no reading.
sensor_value() {
	local value="" divisor=${2:-1}
	{ IFS= read -r value <"$1"; } 2>/dev/null || true
	if [[ $value =~ ^[0-9]+$ ]]; then
		echo $((10#$value / divisor))
	fi
}

# Print file $2 from the hwmon named $1, or nothing if unavailable. The hwmon
# is selected by file $3, defaulting to $2. $4 optionally scales the value.
hwmon_value() {
	local name=$1 file=$2 dir
	dir=${ find_hwmon "$name" "${3:-$file}";} || return 0
	sensor_value "$dir/$file" "${4:-1}"
}
