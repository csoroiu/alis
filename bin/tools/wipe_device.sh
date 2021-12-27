#!/bin/bash -e
readonly PROGNAME=$(basename "$0")
readonly PROGDIR="$(dirname -- "$(readlink -f -- "$0")")"
readonly ARGS=("$@")

function wipe_fs_partx ( )
{
   local device=$1

    echo ""
    echo "Wiping out any existing filesystems on all partitions"
    # removing signatures of filesystem
    flock "${device}" wipefs -a -f "${device}"? || :
    # removing partitions from kernel (does not delete anything on device)
    echo "Delete partitions from kernel"
    flock "${device}" partx -v -d "${device}" || :
    # removing signatures of partition table
    echo "Wiping out the partition table"
    flock "${device}" wipefs -a -f "${device}" || :

}

if [[ $# -eq 0 ]]; then
    echo "No arguments provided"
    exit 1
fi
if [[ "$EUID" -ne 0 ]]; then
  echo "Please run as root"
  exit
fi
device=$1

wipe_fs_partx "${device}"
