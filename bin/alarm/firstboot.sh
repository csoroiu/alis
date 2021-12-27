#!/bin/bash
readonly PROGNAME=$(basename "$0")
readonly PROGDIR="$(dirname -- "$(readlink -f -- "$0")")"
readonly ARGS=("$@")

"${PROGDIR}/prepare-update-system.sh"
"${PROGDIR}/install-yay.sh"
deploy_user=alarm
cp -a "${PROGDIR}/alarm-user-settings.sh" /tmp
sudo -H -u ${deploy_user} "/tmp/alarm-user-settings.sh"

