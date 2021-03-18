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

device=$1

echo ""
echo Writing u-boot image
dd if=odroidxu-uboot.img of=${device} bs=512 seek=1
sync -d ${device}
partx -v -u ${device}

echo ""
echo Mounting boot and root 
mkdir boot
mkdir root
mount ${device}1 boot
mount ${device}2 root

echo ""
echo "Unpacking the image"
bsdtar -xpf ArchLinuxARM-odroid-xu-latest.tar.gz -C root
sync -d ${device}

mv root/boot/* boot

echo ""
echo "Patching files"
cp -a boot/boot.ini boot/boot.ini.original
comment_line "setenv fdt_high" boot/boot.ini
sed -e 's/0x41f00000/0x4fff2000/g' -i boot/boot.ini

cp -a root/etc/locale.gen root/etc/locale.gen.original
uncomment_line "^#en_US" root/etc/locale.gen
cp -a root/etc/pacman.conf root/etc/pacman.conf.original
uncomment_line "^#Color" root/etc/pacman.conf

if [[ ! -z ${ALIS_DEPLOY_HOSTNAME} ]]; then
    cp -a root/etc/hostname root/etc/hostname.original
    echo "Setting hostname to \"${ALIS_DEPLOY_HOSTNAME}\""
    echo ${ALIS_DEPLOY_HOSTNAME} > root/etc/hostname
else
    echo "Using default hostname \"$(cat root/etc/hostname)\""
fi

cp -r "${PROGDIR}/alarm/" root/root

echo ""
echo Unmounting
umount boot root
