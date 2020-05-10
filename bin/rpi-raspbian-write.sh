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

if [[ $# -ne 2 ]]; then
    echo "Invalid arguments provided."
    echo "First argument needs to be the device where to write the image"
    echo "Second argument needs to be the distro name:"
    echo " raspbian_full_latest"
    echo " raspbian_latest"
    echo " raspbian_lite_latest"
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
echo "Unpacking the image"
#Image should have the same name as the zip but different extension
image_name="$(basename ${file_name} .zip).img"
#extract only that image file
unzip -o ${file_name} ${image_name}

echo "Writing image on sdd"
dd bs=4M if=${image_name} of=${device} conv=fsync
sync -d ${device}

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