#!/bin/bash

function resolve_final_url ( )
{
    wget -S -nv --spider -N --content-disposition "$*" 2>&1 | grep -e Location | tail -n 1 | sed -e 's/^.*Location:\s*//'
}

function get_arch_linux_mirror ( )
{
    local parent="$*"
    local mirror=
    for i in $(seq 1 30); do
        mirror=$(resolve_final_url "${parent}")
    if [[ -z ${mirror} ]]; then
        mirror="${parent}"
        break
    # skip greek mirror, does not return the modify time and file will download everytime
    elif [[ "${mirror}" =~ /gr.mirror.archlinuxarm.org ]]; then
        mirror="${parent}"
        continue
    else
        break
    fi
    done
    echo "${mirror}"
}


function download_if_newer ( )
{
    echo "Downloading $*"
    # use -P to specify the output directory
    wget --backups=5 -N --content-disposition "$*"
}

function download_if_newer_arch_linux ( )
{
    echo "Resolving $*"
    download_if_newer "$(get_arch_linux_mirror "$*")"
}

function get_file_name_from_url ( )
{
    local file_name="$*"
    #get file name part
    file_name="${file_name##*/}"
    #remove query string
    file_name="${file_name%%\?*}"
    #unescape url encoded names
    file_name=$(printf '%b' "${file_name//%/\\x}")
    echo "${file_name}"
}
