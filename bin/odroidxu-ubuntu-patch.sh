#!/bin/bash
readonly PROGNAME=$(basename "$0")
readonly PROGDIR="$(dirname -- "$(readlink -f -- "$0")")"
readonly ARGS="$*"

. "$PROGDIR"/patch-functions.sh --source-only

if [[ $# -ne 1 ]]; then
    echo "Invalid arguments provided. Needs to receive the device where to write the image."
    exit 1
fi

if [[ "$EUID" -ne 0 ]]; then
  echo "Please run as root"
  exit
fi

device="$1"

mount_boot_root "${device}"

#Patch code goes below
echo ""
echo "Patching files"
#touch boot/ssh

cp -a root/etc/locale.gen root/etc/locale.gen.original
uncomment_line "^#en_US" root/etc/locale.gen

if [[ -n ${ALIS_DEPLOY_HOSTNAME} ]]; then
    cp -a root/etc/hostname root/etc/hostname.original
    echo "Setting hostname to \"${ALIS_DEPLOY_HOSTNAME}\""
    echo "${ALIS_DEPLOY_HOSTNAME}" > root/etc/hostname
else
    echo "Using default hostname \"$(cat root/etc/hostname)\""
fi

echo "Credentials are:"
echo "  Username: root"
echo "  Password: odroid"

umount_device "${device}"
