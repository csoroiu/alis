#!/bin/bash

function get_arch_mirror ( )
{
    local parent=$@
    local mirror=
    for i in $(seq 1 30); do
        mirror=$(wget -S -nv --spider -N --content-disposition $@ 2>&1 | grep -e Location | sed -e 's/^.*Location:\s*//')
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
    wget --backups=5 -N --content-disposition $@
}

function download_if_newer_arch ( )
{
    echo "Resolving $@"
    download_if_newer $(get_arch_mirror $@)
}

function get_file_name_from_url ( )
{
    local file_name=$@
    #get file name part
    file_name="${file_name##*/}"
    #remove query string
    file_name="${file_name%%\?*}"
    #unescape url encoded names
    file_name=$(printf '%b' ${file_name//%/\\x})
    echo "${file_name}"
}
