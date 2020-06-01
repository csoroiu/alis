#!/bin/bash

function comment_line ( )
{
    local pattern=$1
    local file=$2
    sed "/${pattern}/s/^/#/g" -i "${file}"
}

function uncomment_line ( )
{
    local pattern=$1
    local file=$2
    sed "/${pattern}/s/^#//g" -i "${file}"
}

function mount_boot_root ( )
{
    local device="$1"

    echo ""
    echo Mounting boot and root
    mkdir boot
    mkdir root
    mount ${device}1 boot
    mount ${device}2 root
}

function umount_device ( )
{
    echo ""
    echo Unmounting
    umount "${device}"?* || :
}
