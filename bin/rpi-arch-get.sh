#!/bin/bash -e
readonly PROGNAME=$(basename $0)
readonly PROGDIR="$(dirname -- "$(readlink -f -- "$0")")"
readonly ARGS="$@"

. $PROGDIR/download-functions.sh --source-only

if [[ $# -ne 1 ]]; then
    echo "Invalid arguments provided. Needs to receive the distro name:"
    echo " rpi-2: for 32bit rpi-2 and rpi-3"
    echo " rpi-4: for 32bit rpi-4"
    echo " rpi-aarch64: for 64bit rpi-3 and rpi-4"
    exit 1
fi

distro="$1"

url=http://os.archlinuxarm.org/os/ArchLinuxARM-${distro}-latest.tar.gz
file_name="$(get_file_name_from_url ${url})"

#The mirror in greece does not answer with the file's timestamp
echo ""
download_if_newer_arch ${url}
echo ""
download_if_newer_arch "${url}.md5"

echo ""
echo "Checking md5 sum"
md5sum -c "${file_name}.md5"

