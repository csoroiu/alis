#!/bin/bash
readonly PROGNAME=$(basename $0)
readonly PROGDIR=$(readlink -m $(dirname $0))
readonly ARGS="$@"

. $PROGDIR/download-functions.sh --source-only

#downloading the xu-boot binary
#dd if=odroidxu-uboot.img of=${device} bs=512 seek=1
echo ""
download_if_newer http://s3.armhf.com/dist/odroid/odroidxu-uboot.img

#downloading the complete image with ubuntu 14.04
#xz -k -d ubuntu-14.04lts-server-odroid-xu-20140714.img.xz
#dd if=/dev/zero of=${device} bs=1M
#dd if=ubuntu-14.04lts-server-odroid-xu-20140714.img of=${device} bs=1M
echo ""
download_if_newer https://odroid.in/ubuntu_14.04lts/ubuntu-14.04lts-server-odroid-xu-20140714.img.xz
echo ""
download_if_newer https://odroid.in/ubuntu_14.04lts/ubuntu-14.04lts-server-odroid-xu-20140714.img.xz.md5sum
md5sum -c ubuntu-14.04lts-server-odroid-xu-20140714.img.xz.md5sum
