#!/bin/bash -e
readonly PROGNAME=$(basename "$0")
readonly PROGDIR="$(dirname -- "$(readlink -f -- "$0")")"
readonly ARGS=("$@")

. "$PROGDIR"/download-functions.sh --source-only

UBUNTU_VERSION=${UBUNTU_VERSION:=22.04.1}

if [[ $# -ne 1 ]]; then
    echo "Invalid arguments provided. Needs to receive the distro name: armhf, arm64"
    echo "The UBUNTU_VERSION variable controls the version to download."
    exit 1
fi

distro="$1"

image_url="https://cdimage.ubuntu.com/releases/${UBUNTU_VERSION}/release/ubuntu-${UBUNTU_VERSION}-preinstalled-server-${distro}+raspi.img.xz"
file_name="$(get_file_name_from_url "${image_url}")"
sha256sums_url="https://cdimage.ubuntu.com/releases/${UBUNTU_VERSION}/release/SHA256SUMS"

sha256sums_file_name="ubuntu-${UBUNTU_VERSION}-preinstalled-server-${distro}+raspi.img.xz.sha256"
echo ""
download_if_newer "${image_url}"
echo ""
download_if_newer -O "${sha256sums_file_name}" "${sha256sums_url}"

echo ""
echo "Checking sha256 sum"
grep "${file_name}" "${sha256sums_file_name}" | sha256sum -c
