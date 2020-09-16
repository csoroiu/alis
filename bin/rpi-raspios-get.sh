#!/bin/bash -e
readonly PROGNAME=$(basename $0)
readonly PROGDIR="$(dirname -- "$(readlink -f -- "$0")")"
readonly ARGS="$@"

. $PROGDIR/download-functions.sh --source-only

if [[ $# -ne 1 ]]; then
    echo "Invalid arguments provided. Needs to receive the distro name:"
    echo " raspios_full_armhf_latest, raspios_armhf_latest, raspios_lite_armhf_latest,"
    echo " raspios_arm64_latest, raspios_lite_arm64_latest"
    exit 1
fi

distro="$1"

image_url="$(resolve_final_url https://downloads.raspberrypi.org/${distro})"
echo ""
download_if_newer "${image_url}"
echo ""
download_if_newer "${image_url}.sha256"

image_name="$(get_file_name_from_url ${image_url})"
image_sha256="${image_name}.sha256"

echo ""
echo "Checking sha256 sum"
grep "${file_name}" "${image_sha256}" | sha256sum -c

old_file_name=$(readlink -- "${distro}.zip" || :)
old_file_name_sha256=$(readlink -- "${distro}.zip.sha256" || :)

if [[ "${old_file_name}" != "${image_name}" ]]; then
  if [[ -f "${old_file_name}" ]]; then 
    echo "Deleting old image: ${old_file_name}" 
    unlink "${old_file_name}" || :
  fi
  if [[ -f "${old_file_name_sha256}" ]]; then
    echo "Deleting old sha256: ${old_file_name_sha256}"
    unlink "${old_file_name_sha256}" || :
  fi

  ln -sfn "${image_name}" "${distro}.zip"
  ln -sfn "${image_name}.sha256" "${distro}.zip.sha256"
fi
