#!/bin/bash
readonly PROGNAME=$(basename "$0")
readonly PROGDIR="$(dirname -- "$(readlink -f -- "$0")")"
readonly ARGS=("$@")

. "$PROGDIR"/patch-functions.sh --source-only

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
sync -d "${device}"
partx -v -u "${device}"

echo ""
echo Mounting boot and root 
mkdir boot
mkdir root
mount "${device}"1 boot
mount "${device}"2 root

echo ""
echo "Unpacking the image"
bsdtar -xpf ArchLinuxARM-armv7-latest.tar.gz -C root
sync -d "${device}"

mv root/boot/* boot

echo ""
echo "Patching files"
#copy our boot.ini
cp "${PROGDIR}/alarm-odroid/boot.ini" boot/boot.ini
cp -a boot/boot.ini boot/boot.ini.original

cp "${PROGDIR}/alarm-odroid/fstab" root/etc/fstab
cp -a root/etc/fstab root/etc/fstab.original

#to avoid random stuck boot use PARTUUID for rootfs and for boot partision
#boot process does not work with UUID, only with PARTUUID
ROOT_PARTUUID=$(blkid -o export "${device}"2 | grep ^PARTUUID=)
sed -e "s/\/dev\/mmcblk1p2/${ROOT_PARTUUID}/g" -i boot/boot.ini
#mounting also works with UUID instead of PARTUUID
BOOT_PARTUUID=$(blkid -o export "${device}"1 | grep ^PARTUUID=)
sed -e "s/\/dev\/mmcblk1p1/${BOOT_PARTUUID}/g" -i root/etc/fstab

cp -a root/etc/locale.gen root/etc/locale.gen.original
uncomment_line "^#en_US" root/etc/locale.gen
cp -a root/etc/pacman.conf root/etc/pacman.conf.original
uncomment_line "^#Color" root/etc/pacman.conf

if [[ -n ${ALIS_DEPLOY_HOSTNAME} ]]; then
    cp -a root/etc/hostname root/etc/hostname.original
    echo "Setting hostname to \"${ALIS_DEPLOY_HOSTNAME}\""
    echo "${ALIS_DEPLOY_HOSTNAME}" > root/etc/hostname
else
    echo "Using default hostname \"$(cat root/etc/hostname)\""
fi

cp -r "${PROGDIR}/alarm/" root/root

echo ""
echo Unmounting
umount boot root
