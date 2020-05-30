#!/bin/bash -e
readonly PROGNAME=$(basename $0)
readonly PROGDIR="$(dirname -- "$(readlink -f -- "$0")")"
readonly ARGS="$@"

if [[ $# -ne 2 ]]; then
    echo "Invalid arguments provided."
    echo "First argument needs to be the device where to write the image"
    echo "Second argument needs to be the distro name:"
    echo " RPi2: for rpi-2 and rpi-3"
    echo " RPi4: for rpi-4"
    exit 1
fi

device="$1"
distro="$2"

"${PROGDIR}/rpi-libreELEC-9.2.1-get.sh" ${distro}

echo ""
echo "Unmounting all partitions for ${device}"
sudo umount ${device}?* || :

sudo "${PROGDIR}/rpi-libreELEC-9.2.1-write.sh" ${device} ${distro}
