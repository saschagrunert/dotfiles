#!/usr/bin/env bash

set -o noclobber -o noglob -o nounset -o pipefail
IFS=$'\n'

# Script arguments
FILE_PATH="${1}" # Full path of the highlighted file
PV_WIDTH="${2}"  # Width of the preview pane (number of fitting characters)
# shellcheck disable=SC2034
PV_HEIGHT="${3}" # Height of the preview pane (number of fitting characters)
# shellcheck disable=SC2034
IMAGE_CACHE_PATH="${4}" # Full path that should be used to cache image preview
# shellcheck disable=SC2034
PV_IMAGE_ENABLED="${5}" # 'True' if image previews are enabled, 'False' otherwise.

FILE_EXTENSION="${FILE_PATH##*.}"
FILE_EXTENSION_LOWER=$(echo "${FILE_EXTENSION}" | tr '[:upper:]' '[:lower:]')

# Settings
BAT_SIZE_MAX=262143 # 256KiB
BAT_TABWIDTH=4

# Exit codes: 5 = preview shown, 2 = let ranger display the raw file, 1 = failure

handle_extension() {
	case "${FILE_EXTENSION_LOWER}" in
	# Archives (everything libarchive can read)
	7z | a | ar | bz | bz2 | cab | cpio | deb | gz | iso | jar | lha | lz | lzh | lzma | lzo | \
		rar | rpm | tar | tbz | tbz2 | tgz | tlz | txz | tzo | war | xpi | xz | z | zip | zst)
		bsdtar --list --file "${FILE_PATH}" && exit 5
		exit 1
		;;

	# PDF
	pdf)
		exiftool "${FILE_PATH}" && exit 5
		exit 1
		;;
	esac
}

handle_mime() {
	local mimetype="${1}"
	case "${mimetype}" in
	# Text
	text/* | */xml | application/json | application/javascript)
		if [[ "$(stat --printf='%s' -- "${FILE_PATH}")" -gt "${BAT_SIZE_MAX}" ]]; then
			exit 2
		fi
		bat --color=always --style=plain --tabs="${BAT_TABWIDTH}" \
			--terminal-width="${PV_WIDTH}" -- "${FILE_PATH}" && exit 5
		exit 2
		;;

	# Image
	image/*)
		exiftool "${FILE_PATH}" && exit 5
		exit 1
		;;

	# Video and audio
	video/* | audio/*)
		mediainfo "${FILE_PATH}" && exit 5
		exiftool "${FILE_PATH}" && exit 5
		exit 1
		;;
	esac
}

handle_fallback() {
	echo '----- File Type Classification -----' && file --dereference --brief -- "${FILE_PATH}" && exit 5
	exit 1
}

MIMETYPE="$(file --dereference --brief --mime-type -- "${FILE_PATH}")"
handle_extension
handle_mime "${MIMETYPE}"
handle_fallback

# shellcheck disable=SC2317
exit 1
