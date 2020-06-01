#!/bin/bash -e
readonly PROGNAME=$(basename $0)
readonly PROGDIR="$(dirname -- "$(readlink -f -- "$0")")"
readonly ARGS="$@"

if [[ $# -ne 2 ]]; then
    echo "Invalid arguments provided."
    echo "First argument needs to be the device where to write the image"
    echo "Second argument needs to be the distro name:"
    echo " armhf: for rpi-2,3,4"
    echo " arm64: for rpi-3,4"
    exit 1
fi

device="$1"
distro="$2"


#downloading file
"${PROGDIR}/rpi-ubuntu-get.sh" ${distro}

#real file_name is known only after download
file_name="ubuntu-20.04-preinstalled-server-${distro}+raspi.img.xz"

#writing image to disk
sudo "${PROGDIR}/write-image.sh" "${device}" "${file_name}"

#patching distro
sudo "${PROGDIR}/rpi-ubuntu-patch.sh" ${device}
