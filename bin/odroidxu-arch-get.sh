#!/bin/bash
readonly PROGNAME=$(basename $0)
readonly PROGDIR=$(readlink -m $(dirname $0))
readonly ARGS="$@"

. $PROGDIR/download-functions.sh --source-only

#downloading the xu-boot binary
echo ""
download_if_newer http://s3.armhf.com/dist/odroid/odroidxu-uboot.img
#dd if=odroidxu-uboot.img of=${device} bs=512 seek=1

#using mirror from hungary. The mirror in greece does not answer with the file's timestamp
echo ""
download_if_newer_arch http://os.archlinuxarm.org/os/exynos/xuboot.img
echo ""
download_if_newer_arch http://os.archlinuxarm.org/os/ArchLinuxARM-odroid-xu-latest.tar.gz
echo ""
download_if_newer_arch http://os.archlinuxarm.org/os/ArchLinuxARM-odroid-xu-latest.tar.gz.md5
md5sum -c ArchLinuxARM-odroid-xu-latest.tar.gz.md5

