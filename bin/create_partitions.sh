#!/bin/bash -e
readonly PROGNAME=$(basename $0)
readonly PROGDIR="$(dirname -- "$(readlink -f -- "$0")")"
readonly ARGS="$@"

function partition ( )
{
    local device=$1
    echo ""
    echo "Unmounting all partitions for ${device}" 
    #skip mount errors
    umount ${device}?* || :
#    echo Wiping out first 128MB for "${device}"
#    dd if=/dev/zero of=${device} bs=1M count=128
    echo ""
    echo Creating partitions for "${device}"
    sfdisk --delete ${device}
    sfdisk -X dos ${device} << end
    4M,256M,c
    260M,,83
end

    echo ""
    echo Creating and formating the filesystems
    mkfs.vfat ${device}1
    mkfs.ext4 -F ${device}2
    # notify kernel to re-read the partition table
    # partprobe ${device}
    # partx -u ${device}
    # blockdev --rereadpt -v ${device}
    hdparm -z ${device}
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

partition ${device}
