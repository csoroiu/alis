#!/bin/bash -e
readonly PROGNAME=$(basename "$0")
readonly PROGDIR="$(dirname -- "$(readlink -f -- "$0")")"
readonly ARGS="$*"

if [[ $# -ne 2 ]]; then
    echo "Invalid arguments provided."
    echo "First argument needs to be the device where to write the image"
    echo "Second argument needs to be the distro name:"
    echo " rpi-2: for 32bit rpi-2 and rpi-3"
    echo " rpi-4: for 32bit rpi-4"
    echo " rpi-aarch64: for 64bit rpi-3 and rpi-4"
    exit 1
fi

device="$1"
distro="$2"

"${PROGDIR}/rpi-arch-get.sh" "${distro}"
sudo "${PROGDIR}/create_partitions.sh" "${device}"
sudo --preserve-env=ALIS_DEPLOY_HOSTNAME "${PROGDIR}/rpi-arch-write.sh" "${device}" "${distro}"
