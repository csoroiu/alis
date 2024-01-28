#!/bin/bash -e
readonly PROGNAME=$(basename "$0")
readonly PROGDIR="$(dirname -- "$(readlink -f -- "$0")")"
readonly ARGS=("$@")

. "$PROGDIR"/download-functions.sh --source-only

#downloading the xu-boot binary
echo ""
download_if_newer https://s3.armhf.com/dist/odroid/odroidxu-uboot.img
#dd if=odroidxu-uboot.img of=${device} bs=512 seek=1

"${PROGDIR}/arm-arch-get.sh" "armv7"
#"${PROGDIR}/arm-arch-get.sh" "odroid-xu"

