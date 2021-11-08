#!/bin/bash -e
readonly PROGNAME=$(basename "$0")
readonly PROGDIR="$(dirname -- "$(readlink -f -- "$0")")"
readonly ARGS="$*"

. "$PROGDIR"/patch-functions.sh --source-only

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

function partition ( )
{
    local device=$1
    echo ""

    umount_device "${device}"
    wipe_fs_partx "${device}"

    echo ""
    echo "Creating partitions for ${device}"
    flock "${device}" sfdisk -W always "${device}" << end
    label: dos
    unit: sectors

    4M,256M,c,*
    260M,+,83,-
end

    # notify kernel to re-read the partition table
    flock "${device}" partx -v -u "${device}"

    echo ""
    echo "Creating and formating the filesystems"
    # boot partition with boot label
    mkfs.vfat -F 32 -n boot "${device}"1
    # root partition with rootfs label
    mkfs.ext4 -O ^huge_file -L rootfs -F "${device}"2

    # notify kernel to re-read the partition table
    flock "${device}" partx -v -u "${device}"

    # partx -v -u "${device}"
    # partprobe -s ${device}
    # blockdev --rereadpt -v ${device}
    # hdparm -z ${device}
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

partition "${device}"
