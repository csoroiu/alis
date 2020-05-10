#!/bin/bash
readonly PROGNAME=$(basename $0)
readonly PROGDIR=$(readlink -m $(dirname $0))
readonly ARGS="$@"

#sudo -H -u alarm bash -c 'echo "I am $USER, with uid $UID $PWD"'
mkdir ${HOME}/.ssh
touch ${HOME}/.ssh/authorized_keys
chmod og-rwx ${HOME}/.ssh ${HOME}/.ssh/authorized_keys
