#!/bin/bash -e
readonly PROGNAME=$(basename $0)
readonly PROGDIR=$(readlink -m $(dirname $0))
readonly ARGS="$@"

. $PROGDIR/download-functions.sh --source-only

if [[ $# -ne 1 ]]; then
    echo "Invalid arguments provided. Needs to receive the distro name: raspbian_full_latest, raspbian_latest or raspbian_lite_latest"
    exit 1
fi

distro="$1"

#The mirror in greece does not answer with the file's timestamp
image_url="$(get_arch_mirror https://downloads.raspberrypi.org/${distro})"
echo ""
download_if_newer "${image_url}"
echo ""
download_if_newer "${image_url}.sha256"

image_name="${image_url##*/}"
image_sha256="${image_name}.sha256"
sha256sum -c "${image_sha256}" 

