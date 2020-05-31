#!/bin/bash
readonly PROGNAME=$(basename $0)
readonly PROGDIR="$(dirname -- "$(readlink -f -- "$0")")"
readonly ARGS="$@"

. $PROGDIR/archive-functions.sh --source-only

function comment_line ( )
{
    local pattern=$1
    local file=$2
    sed "/${pattern}/s/^/#/g" -i "${file}"
}

function uncomment_line ( )
{
    local pattern=$1
    local file=$2
    sed "/${pattern}/s/^#//g" -i "${file}"
}

if [[ $# -ne 2 ]]; then
    echo "Invalid arguments provided."
    echo "First argument needs to be the device where to write the image"
    echo "Second argument needs to be the distro name:"
    echo " raspios_full_armhf_latest"
    echo " raspios_armhf_latest"
    echo " raspios_lite_armhf_latest"
    exit 1
fi

if [[ "$EUID" -ne 0 ]]; then
  echo "Please run as root"
  exit
fi

device="$1"
distro="$2"

file_name=$(readlink -- "${distro}.zip")

echo ""
echo "Unpacking and writing image on sd card"
eval $(get_unpack_toconsole_command_single_file_archive ${file_name}) | \
  dd bs=4M of=${device} conv=fsync status=progress
partx -v -u ${device}

echo ""
echo Mounting boot and root
mkdir boot
mkdir root
mount ${device}1 boot
mount ${device}2 root

echo ""
echo "Patching files"
touch boot/ssh

cp -a root/etc/locale.gen root/etc/locale.gen.original
uncomment_line "^#en_US" root/etc/locale.gen
cp -a root/etc/hostname root/etc/hostname.original
echo rpiX > root/etc/hostname

cp -r "${PROGDIR}/raspberry" root/home/pi/bin

echo ""
echo Unmounting
umount boot root
