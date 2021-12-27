#!/bin/bash -e
readonly PROGNAME=$(basename "$0")
readonly PROGDIR="$(dirname -- "$(readlink -f -- "$0")")"
readonly ARGS=("$@")

. "$PROGDIR"/download-functions.sh --source-only

LIBREELEC_VERSION=${LIBREELEC_VERSION:=10.0.1}

if [[ $# -ne 1 ]]; then
    echo "Invalid arguments provided. Needs to receive the distro name:"
    echo " RPi2: for rpi-2 and rpi-3"
    echo " RPi4: for rpi-4"
    echo "The LIBREELEC_VERSION variable controls the version to deploy."
    exit 1
fi

distro="$1"

url="http://releases.libreelec.tv/LibreELEC-${distro}.arm-${LIBREELEC_VERSION}.img.gz"
file_name="$(get_file_name_from_url "${url}")"
image_sha256="${file_name}.sha256"

echo ""
download_if_newer "${url}"
echo ""
download_if_newer "${url}.sha256"

echo ""
echo "Checking sha256 sum"
grep "${file_name}" "${image_sha256}" | sha256sum -c

