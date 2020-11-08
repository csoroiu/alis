#!/bin/bash -e
readonly PROGNAME=$(basename $0)
readonly PROGDIR="$(dirname -- "$(readlink -f -- "$0")")"
readonly ARGS="$@"

if [[ $# -ne 2 ]]; then
    echo "Invalid arguments provided."
    echo "First argument needs to be the devic "
    echo "Second argument needs to be number of the partition"
    echo " E.g. ${PROGNAME} /dev/sdd 2"
    exit 1
fi

if [[ "$EUID" -ne 0 ]]; then
  echo "Please run as root"
  exit
fi

device=$1
partition_no=$2
if [[ $device = *[0-9] ]]; then
  partition=${device}p${partition_no}
else
  partition=${device}${partition_no}
fi

echo "Running a check"
flock "${device}" e2fsck -y -f ${partition} -E fixes_only

echo "Modifying partition table"
echo ", +" | flock "${device}" sfdisk -N ${partition_no} ${device}

echo "Resizing the filesystem"
flock "${device}" resize2fs -p ${partition}

#notifying kernel about the changes
flock "${device}" partx -v -u "${device}"
