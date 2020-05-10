#!/bin/bash
readonly PROGNAME=$(basename $0)
readonly PROGDIR=$(readlink -m $(dirname $0))
readonly ARGS="$@"

. $PROGDIR/download-functions.sh --source-only

#The mirror in greece does not answer with the file's timestamp
echo ""
download_if_newer_arch http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-2-latest.tar.gz
echo ""
download_if_newer_arch http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-2-latest.tar.gz.md5
md5sum -c ArchLinuxARM-rpi-2-latest.tar.gz.md5

