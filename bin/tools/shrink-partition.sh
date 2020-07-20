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
partition=${device}${partition_no}


echo "Running a check"
flock "${device}" e2fsck -f ${partition}

echo "Resizing the filesystem"
flock "${device}" resize2fs -p -M ${partition}

echo "Modifying partition table"
#adjusting partition table to ext filesystem size rounded up to 1MB
block_count=$(tune2fs -l ${partition} | grep "Block count" | cut -f 2 -d ':')
block_size=$(tune2fs -l ${partition} | grep "Block size" | cut -f 2 -d ':')
start_sector=$(sfdisk --dump ${device} | grep ${partition} |  cut -f 1 -d ','  | cut -f 2 -d '=')
sector_size=512

fs_size=$(( block_count * block_size ))
fs_sectors=$(( fs_size /sector_size ))
part_sectors=$(( ((fs_sectors - 1) / 2048 + 1) * 2048 ))
end_sector=$(( start_sector + part_sectors - 1 ))

echo ${end_sector}
echo flock "${device}" parted -s ${device} resizepart ${partition_no} ${end_sector}s
echo ",${part_sectors}" | flock "${device}" sfdisk -N ${partition_no} ${device}

#notifying kernel about the changes
flock "${device}" partx -v -u "${device}"
