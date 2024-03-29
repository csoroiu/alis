#!/bin/bash -e
readonly PROGNAME=$(basename "$0")
readonly PROGDIR="$(dirname -- "$(readlink -f -- "$0")")"
readonly ARGS=("$@")

if [[ $# -ne 2 ]]; then
    echo "Invalid arguments provided."
    echo "First argument needs to be the device where to write the image"
    echo "Second argument needs to be the distro name:"
    echo " rpi-armv7: for 32bit rpi-2,3,4"
    echo " rpi-aarch64: for 64bit rpi-3 and rpi-4"
    exit 1
fi

if [[ "$EUID" -eq 0 ]]; then
  echo "Do not run this script as root."
  exit
fi

device="$1"
distro="$2"

"${PROGDIR}/arm-arch-get.sh" "${distro}"
sudo "${PROGDIR}/create_partitions.sh" "${device}"
sudo --preserve-env=ALIS_DEPLOY_HOSTNAME "${PROGDIR}/rpi-arch-write.sh" "${device}" "${distro}"
