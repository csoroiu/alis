#!/bin/bash -e
readonly PROGNAME=$(basename $0)
readonly PROGDIR="$(dirname -- "$(readlink -f -- "$0")")"
readonly ARGS="$@"

if [[ $# -eq 0 ]]; then
    echo "No arguments provided"
    exit 1
fi

device="$1"

"${PROGDIR}/odroidxu-ubuntu-get.sh"

echo ""
echo "Unmounting all partitions for ${device}"
sudo umount ${device}?* || :

sudo "${PROGDIR}/odroidxu-ubuntu-write.sh" ${device}
