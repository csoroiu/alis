#!/bin/bash -e
readonly PROGNAME=$(basename $0)
readonly PROGDIR="$(dirname -- "$(readlink -f -- "$0")")"
readonly ARGS="$@"

UBUNTU_VERSION=${UBUNTU_VERSION:=21.10}

if [[ $# -ne 2 ]]; then
    echo "Invalid arguments provided."
    echo "First argument needs to be the device where to write the image"
    echo "Second argument needs to be the distro name:"
    echo " armhf: for rpi-2,3,4"
    echo " arm64: for rpi-3,4"
    echo "The UBUNTU_VERSION variable controls the version to deploy."
    exit 1
fi

device="$1"
distro="$2"


#downloading file
"${PROGDIR}/rpi-ubuntu-get.sh" ${distro}

#real file_name is known only after download
file_name="ubuntu-${UBUNTU_VERSION}-preinstalled-server-${distro}+raspi.img.xz"

#writing image to disk
sudo --preserve-env=ALIS_DEPLOY_HOSTNAME,UBUNTU_VERSION "${PROGDIR}/write-image.sh" "${device}" "${file_name}"

#patching distro
sudo --preserve-env=ALIS_DEPLOY_HOSTNAME,UBUNTU_VERSION "${PROGDIR}/rpi-ubuntu-patch.sh" ${device}
