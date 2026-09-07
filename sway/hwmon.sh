#!/usr/bin/env bash
# Shared hwmon helpers, sourced by the waybar scripts in this directory.

# Print the sysfs directory of the first hwmon whose name matches $1.
find_hwmon() {
	local name=$1 f
	for f in /sys/class/hwmon/hwmon*/name; do
		if [ "$(cat "$f" 2>/dev/null)" = "$name" ]; then
			dirname "$f"
			return 0
		fi
	done
	return 1
}

# Print the raw value of file $2 from the hwmon named $1, or 0 if unavailable.
hwmon_value() {
	local name=$1 file=$2 dir val
	dir=$(find_hwmon "$name") || {
		echo 0
		return
	}
	val=$(cat "$dir/$file" 2>/dev/null) || val=0
	echo "$val"
}
