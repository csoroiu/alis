#!/bin/bash -e
readonly PROGNAME=$(basename "$0")
readonly PROGDIR="$(dirname -- "$(readlink -f -- "$0")")"
readonly ARGS="$*"

if [[ $# -eq 0 ]]; then
    echo "No arguments provided"
    exit 1
fi

if [[ "$EUID" -eq 0 ]]; then
  echo "Do not run this script as root."
  exit
fi

device="$1"

#downloading file
"${PROGDIR}/odroidxu-ubuntu-get.sh"

#real file_name is known only after download
file_name="ubuntu-14.04lts-server-odroid-xu-20140714.img.xz"

#writing image to disk
sudo --preserve-env=ALIS_DEPLOY_HOSTNAME "${PROGDIR}/write-image.sh" "${device}" "${file_name}"

#echo ""
#echo Writing u-boot image
#dd if=odroidxu-uboot.img of=${device} bs=512 seek=1
#partx -v -u "${device}"

#patching distro
sudo --preserve-env=ALIS_DEPLOY_HOSTNAME "${PROGDIR}/odroidxu-ubuntu-patch.sh" "${device}"
