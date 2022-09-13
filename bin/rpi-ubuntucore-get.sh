#!/bin/bash -e
readonly PROGNAME=$(basename "$0")
readonly PROGDIR="$(dirname -- "$(readlink -f -- "$0")")"
readonly ARGS=("$@")

. "$PROGDIR"/download-functions.sh --source-only

UBUNTU_CORE_VERSION=${UBUNTU_CORE_VERSION:=22}

if [[ $# -ne 1 ]]; then
    echo "Invalid arguments provided. Needs to receive the distro name: armhf, arm64"
    echo "The UBUNTU_CORE_VERSION variable controls the version to download."
    exit 1
fi

distro="$1"

image_url="https://cdimage.ubuntu.com/ubuntu-core/${UBUNTU_CORE_VERSION}/stable/current/ubuntu-core-${UBUNTU_CORE_VERSION}-${distro}+raspi.img.xz"
file_name="$(get_file_name_from_url "${image_url}")"
sha256sums_url="https://cdimage.ubuntu.com/ubuntu-core/${UBUNTU_CORE_VERSION}/stable/current/SHA256SUMS"

sha256sums_file_name="ubuntu-core-${UBUNTU_CORE_VERSION}-${distro}+raspi.img.xz.sha256"
echo ""
download_if_newer "${image_url}"
echo ""
download_if_newer -O "${sha256sums_file_name}" "${sha256sums_url}"

echo ""
echo "Checking sha256 sum"
grep "${file_name}" "${sha256sums_file_name}" | sha256sum -c
