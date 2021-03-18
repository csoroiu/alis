#!/bin/bash -e
readonly PROGNAME=$(basename $0)
readonly PROGDIR="$(dirname -- "$(readlink -f -- "$0")")"
readonly ARGS="$@"

LIBREELEC_VERSION=${LIBREELEC_VERSION:=9.2.6}

if [[ $# -ne 2 ]]; then
    echo "Invalid arguments provided."
    echo "First argument needs to be the device where to write the image"
    echo "Second argument needs to be the distro name:"
    echo " RPi2: for rpi-2 and rpi-3"
    echo " RPi4: for rpi-4"
    echo "The LIBREELEC_VERSION variable controls the version to deploy."
    exit 1
fi

device="$1"
distro="$2"

"${PROGDIR}/rpi-libreELEC-get.sh" ${distro}

#real file_name is known only after download
file_name="LibreELEC-${distro}.arm-${LIBREELEC_VERSION}.img.gz"

#writing image to disk
sudo --preserve-env=ALIS_DEPLOY_HOSTNAME,LIBREELEC_VERSION "${PROGDIR}/write-image.sh" "${device}" "${file_name}"

#patching distro
sudo --preserve-env=ALIS_DEPLOY_HOSTNAME,LIBREELEC_VERSION "${PROGDIR}/generic-patch.sh" "${device}"
