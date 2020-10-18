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

image_url="http://cdimage.ubuntu.com/releases/20.04.1/release/ubuntu-20.04.1-preinstalled-server-${distro}+raspi.img.xz"
file_name="$(get_file_name_from_url ${image_url})"
sha256sums_url="http://cdimage.ubuntu.com/releases/20.04.1/release/SHA256SUMS"

sha256sums_file_name="ubuntu-20.04.1-preinstalled-server-raspi.img.xz.sha256"
echo ""
download_if_newer "${image_url}"
echo ""
download_if_newer "-O ${sha256sums_file_name} ${sha256sums_url}"

echo ""
echo "Checking sha256 sum"
grep "${file_name}" "${sha256sums_file_name}" | sha256sum -c
