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
	for f in /sys/class/hwmon/hwmon*/name; do
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

# Print the raw value of file $2 from the hwmon named $1, or 0 if unavailable.
# The hwmon is selected by file $3, defaulting to $2.
hwmon_value() {
	local name=$1 file=$2 dir value
	dir=$(find_hwmon "$name" "${3:-$file}") || {
		echo 0
		return
	}
	IFS= read -r value <"$dir/$file" 2>/dev/null || [ -n "$value" ] || value=0
	echo "${value:-0}"
}
