#!/bin/bash -e
readonly PROGNAME=$(basename $0)
readonly PROGDIR="$(dirname -- "$(readlink -f -- "$0")")"
readonly ARGS="$@"

if [[ $# -ne 2 ]]; then
    echo "Invalid arguments provided."
    echo "First argument needs to be the device where to write the image"
    echo "Second argument needs to be the distro name:"
    echo " raspios_full_armhf_latest, raspios_armhf_latest, raspios_lite_armhf_latest,"
    echo " raspios_arm64_latest, raspios_lite_arm64_latest"
    exit 1
fi

device="$1"
distro="$2"

#downloading file
"${PROGDIR}/rpi-raspios-get.sh" ${distro}

#real file_name is known only after download
file_name=$(readlink -- "${distro}.zip")

#writing image to disk
sudo "${PROGDIR}/write-image.sh" "${device}" "${file_name}"

#patching distro
sudo "${PROGDIR}/rpi-raspios-patch.sh" ${device}
