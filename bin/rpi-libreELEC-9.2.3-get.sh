#!/bin/bash -e
readonly PROGNAME=$(basename $0)
readonly PROGDIR="$(dirname -- "$(readlink -f -- "$0")")"
readonly ARGS="$@"

. $PROGDIR/download-functions.sh --source-only

if [[ $# -ne 1 ]]; then
    echo "Invalid arguments provided. Needs to receive the distro name:"
    echo " RPi2: for rpi-2 and rpi-3"
    echo " RPi4: for rpi-4"
    exit 1
fi

distro="$1"

url="http://releases.libreelec.tv/LibreELEC-${distro}.arm-9.2.3.img.gz"
file_name="$(get_file_name_from_url ${url})"
image_sha256="${file_name}.sha256"

echo ""
download_if_newer ${url}
echo ""
download_if_newer "${url}.sha256"

echo ""
echo "Checking sha256 sum"
grep "${file_name}" "${image_sha256}" | sha256sum -c

