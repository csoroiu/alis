#!/bin/bash
readonly PROGNAME=$(basename "$0")
readonly PROGDIR="$(dirname -- "$(readlink -f -- "$0")")"
readonly ARGS=("$@")

. "$PROGDIR"/patch-functions.sh --source-only

if [[ $# -ne 2 ]]; then
    echo "Invalid arguments provided."
    echo "First argument needs to be the device where to write the image"
    echo "Second argument needs to be the distro name:"
    echo " rpi-armv7: for 32bit rpi-2,3,4"
    echo " rpi-aarch64: for 64bit rpi-3 and rpi-4"
    exit 1
fi

if [[ "$EUID" -ne 0 ]]; then
  echo "Please run as root"
  exit
fi

device="$1"
distro="$2"

file_name=ArchLinuxARM-${distro}-latest.tar.gz

echo ""
echo Mounting boot and root 
mkdir boot
mkdir root
mount "${device}"1 boot
mount "${device}"2 root

echo ""
echo "Unpacking the image"
bsdtar -xpf "${file_name}" -C root
sync -d "${device}"
mv root/boot/* boot

echo ""
echo "Patching files"
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
cp -r "${PROGDIR}/raspberry" root/home/alarm/bin


echo ""
echo Unmounting
sync -d "${device}"
umount boot root

echo "for pi4 run:"
echo "sed -i 's/mmcblk0/mmcblk1/g' root/etc/fstab"

