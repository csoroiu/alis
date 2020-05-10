#!/bin/bash

function get_arch_mirror ( )
{
    local parent=$@
    local mirror=
    for i in $(seq 1 30); do
        mirror=$(wget -S -nv --spider -N $@ 2>&1 | grep -e Location | sed -e 's/^.*Location:\s*//')
	if [[ -z ${mirror} ]]; then
	    mirror=$@
	    break
	elif [[ "${mirror}" =~ "/gr.mirror." ]]; then
	    mirror=$@
	    continue
	else
            break
        fi
    done
    echo ${mirror}
}

function download_if_newer ( )
{
    echo "Downloading $@"
    # use -P to specify the output directory
    wget --no-verbose --backups=5 -N $@
}

function download_if_newer_arch ( )
{
    echo "Resolving $@"
    download_if_newer $(get_arch_mirror $@)
}
