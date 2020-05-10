#!/bin/bash
readonly PROGNAME=$(basename $0)
readonly PROGDIR=$(readlink -m $(dirname $0))
readonly ARGS="$@"

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

if [[ $# -eq 0 ]]; then
    echo "No arguments provided"
    exit 1
fi
if [[ "$EUID" -ne 0 ]]
  then echo "Please run as root"
  exit
fi

device=$1

echo ""
echo Mounting boot and root 
mkdir boot
mkdir root
mount ${device}1 boot
mount ${device}2 root

echo ""
echo "Unpacking the image"
bsdtar -xpf ArchLinuxARM-rpi-3-latest.tar.gz -C root
sync -d ${device}
mv root/boot/* boot

echo ""
echo "Patching files"
cp -a root/etc/locale.gen root/etc/locale.gen.original
uncomment_line "^#en_US" root/etc/locale.gen
cp -a root/etc/pacman.conf root/etc/pacman.conf.original
uncomment_line "^#Color" root/etc/pacman.conf
cp -a root/etc/hostname root/etc/hostname.original
echo alarmpi3 > root/etc/hostname

cp -r "${PROGDIR}/alarm/" root/root
cp -r "${PROGDIR}/raspberry" root/home/alarm/bin


echo ""
echo Unmounting
umount boot root
