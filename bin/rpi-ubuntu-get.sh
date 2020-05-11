#!/bin/bash -e
readonly PROGNAME=$(basename $0)
readonly PROGDIR="$(dirname -- "$(readlink -f -- "$0")")"
readonly ARGS="$@"

. $PROGDIR/download-functions.sh --source-only

if [[ $# -ne 1 ]]; then
    echo "Invalid arguments provided. Needs to receive the distro name: armhf, arm64"
    exit 1
fi

distro="$1"

#The mirror in greece does not answer with the file's timestamp

image_url="http://cdimage.ubuntu.com/releases/20.04/release/ubuntu-20.04-preinstalled-server-${distro}+raspi.img.xz"
sha256sums_url="http://cdimage.ubuntu.com/releases/20.04/release/SHA256SUMS"

sha256sums_file_name="ubuntu-20.04-preinstalled-server-raspi.img.xz.sha256"
echo ""
download_if_newer "${image_url}"
echo ""
download_if_newer "-O ${sha256sums_file_name} ${sha256sums_url}"

echo ""
echo "Checking sha256 sum"
sha256sum -c --ignore-missing "${sha256sums_file_name}"

