#!/bin/bash -e
readonly PROGNAME=$(basename "$0")
readonly PROGDIR="$(dirname -- "$(readlink -f -- "$0")")"
readonly ARGS=("$@")

. "$PROGDIR"/download-functions.sh --source-only

LIBREELEC_VERSION=${LIBREELEC_VERSION:=10.0.2}

if [[ $# -ne 1 ]]; then
    echo "Invalid arguments provided. Needs to receive the distro name:"
    echo " RPi2: for rpi-2 and rpi-3"
    echo " RPi4: for rpi-4,400,cm4"
    echo "The LIBREELEC_VERSION variable controls the version to deploy."
    exit 1
fi

distro="$1"

url="https://releases.libreelec.tv/LibreELEC-${distro}.arm-${LIBREELEC_VERSION}.img.gz"
file_name="$(get_file_name_from_url "${url}")"
releases_url="https://releases.libreelec.tv/releases.json"

releases_file_name="LibreELEC-releases.json"

#jq -r '.. | ."image"? | select(."name"=="LibreELEC-RPi4.arm-10.0.2.img.gz")| .sha256 + " " + .name'

echo ""
download_if_newer "${url}"
echo ""
download_if_newer -O "${releases_file_name}" "${releases_url}"

echo ""
echo "Checking sha256 sum"
jq -r '.. | ."image"? | select(."name"=="'${file_name}'")| .sha256 + " " + .name' ${releases_file_name} | sha256sum -c

