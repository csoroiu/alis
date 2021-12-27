#!/bin/bash -e
readonly PROGNAME=$(basename "$0")
readonly PROGDIR="$(dirname -- "$(readlink -f -- "$0")")"
readonly ARGS=("$@")

if [[ $# -eq 0 ]]; then
    echo "No arguments provided"
    exit 1
fi

if [[ "$EUID" -eq 0 ]]; then
  echo "Do not run this script as root."
  exit
fi

device=$1

"${PROGDIR}/odroidxu-arch-get.sh"
sudo "${PROGDIR}/create_partitions.sh" ${device}
sudo --preserve-env=ALIS_DEPLOY_HOSTNAME "${PROGDIR}/odroidxu-arch-write.sh" ${device}
