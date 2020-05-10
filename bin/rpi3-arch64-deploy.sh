#!/bin/bash -e
readonly PROGNAME=$(basename $0)
readonly PROGDIR="$(dirname -- "$(readlink -f -- "$0")")"
readonly ARGS="$@"

if [[ $# -eq 0 ]]; then
    echo "No arguments provided"
    exit 1
fi

device=$1

"${PROGDIR}/rpi-arch-get.sh" rpi-3
sudo "${PROGDIR}/create_partitions.sh" ${device}
sudo "${PROGDIR}/rpi3-arch64-write.sh" ${device}
