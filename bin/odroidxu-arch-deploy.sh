#!/bin/bash
readonly PROGNAME=$(basename $0)
readonly PROGDIR=$(readlink -m $(dirname $0))
readonly ARGS="$@"

if [[ $# -eq 0 ]]; then
    echo "No arguments provided"
    exit 1
fi

device=$1

"${PROGDIR}/odroidxu-arch-get.sh"
sudo "${PROGDIR}/create_partitions.sh" ${device}
sudo "${PROGDIR}/odroidxu-arch-write.sh" ${device}
