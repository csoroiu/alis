#!/bin/bash
readonly PROGNAME=$(basename "$0")
readonly PROGDIR="$(dirname -- "$(readlink -f -- "$0")")"
readonly ARGS=("$@")

. "$PROGDIR"/download-functions.sh --source-only

#downloading the xu-boot binary
#dd if=odroidxu-uboot.img of=${device} bs=512 seek=1
echo ""
download_if_newer https://s3.armhf.com/dist/odroid/odroidxu-uboot.img

echo ""
download_if_newer https://odroid.in/ubuntu_14.04lts/ubuntu-14.04lts-server-odroid-xu-20140714.img.xz
echo ""
download_if_newer https://odroid.in/ubuntu_14.04lts/ubuntu-14.04lts-server-odroid-xu-20140714.img.xz.md5sum

echo ""
echo "Checking md5 sum"
md5sum -c ubuntu-14.04lts-server-odroid-xu-20140714.img.xz.md5sum
