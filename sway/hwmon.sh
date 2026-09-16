#!/usr/bin/env bash
# Shared hwmon helpers, sourced by the waybar scripts in this directory.

# Print the sysfs directory of the first hwmon whose name matches $1 and which
# provides file $2 (optional). This tells apart devices sharing a name, such as
# the discrete and integrated amdgpu, where only the discrete one has a fan.
find_hwmon() {
	local name=$1 required=${2:-name} f dir
	for f in /sys/class/hwmon/hwmon*/name; do
		dir=$(dirname "$f")
		if [ "$(cat "$f" 2>/dev/null)" = "$name" ] && [ -e "$dir/$required" ]; then
			echo "$dir"
			return 0
		fi
	done
	return 1
}

# Print the raw value of file $2 from the hwmon named $1, or 0 if unavailable.
# The hwmon is selected by file $3, defaulting to $2.
hwmon_value() {
	local name=$1 file=$2 dir val
	dir=$(find_hwmon "$name" "${3:-$file}") || {
		echo 0
		return
	}
	val=$(cat "$dir/$file" 2>/dev/null) || val=0
	echo "$val"
}
