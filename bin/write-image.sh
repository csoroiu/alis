#!/bin/bash -e
readonly PROGNAME=$(basename "$0")
readonly PROGDIR="$(dirname -- "$(readlink -f -- "$0")")"
readonly ARGS=("$@")

. "$PROGDIR"/archive-functions.sh --source-only
. "$PROGDIR"/patch-functions.sh --source-only

function write_image ( )
{
    local device=$1
    local file_name=$2
    umount_device "${device}"
    echo ""
    echo "Unpacking and writing image on sd card"
    eval "$(get_unpack_to_stdout_command_single_file_archive "${file_name}")" | \
        dd bs=4M of="${device}" conv=fsync status=progress
    partx -v -u "${device}" || :
}


if [[ $# -ne 2 ]]; then
    echo "Invalid arguments provided."
    echo "First argument needs to be the device where to write the image"
    echo "Second argument needs to be the image file or image archive."
    exit 1
fi

if [[ "$EUID" -ne 0 ]]; then
  echo "Please run as root"
  exit
fi

write_image "$@"
