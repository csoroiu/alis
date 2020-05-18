#!/bin/bash
readonly PROGNAME=$(basename $0)
readonly PROGDIR="$(dirname -- "$(readlink -f -- "$0")")"
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

if [[ "$EUID" -ne 0 ]]; then
  echo "Please run as root"
  exit
fi

device="$1"

file_name="ubuntu-14.04lts-server-odroid-xu-20140714.img.xz"

echo ""
echo "Unpacking the image"
#Image should have the same name as the zip but different extension
image_name="$(basename ${file_name} .xz)"
#extract the image file
xz -k -v -f -d ${file_name}

echo "Writing image on sd card"
dd bs=4M if=${image_name} of=${device} conv=fsync status=progress
sync -d ${device}

#echo ""
#echo Writing u-boot image
#dd if=odroidxu-uboot.img of=${device} bs=512 seek=1
#sync -d ${device}

echo ""
echo Mounting boot and root
mkdir boot
mkdir root
mount ${device}1 boot
mount ${device}2 root

echo ""
echo "Patching files"
#touch boot/ssh

cp -a root/etc/locale.gen root/etc/locale.gen.original
uncomment_line "^#en_US" root/etc/locale.gen
cp -a root/etc/hostname root/etc/hostname.original
echo odroid > root/etc/hostname

echo "Credentials are:"
echo "  Username: root"
echo "  Password: odroid"

echo ""
echo Unmounting
umount boot root

