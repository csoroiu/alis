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

"${PROGDIR}/rpi-ubuntu-get.sh" ${distro}

echo ""
echo "Unmounting all partitions for ${device}"
sudo umount ${device}?* || :

sudo "${PROGDIR}/rpi-ubuntu-write.sh" ${device} ${distro}
