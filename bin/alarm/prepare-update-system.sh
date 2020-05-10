#!/bin/bash
readonly PROGNAME=$(basename $0)
readonly PROGDIR=$(readlink -m $(dirname $0))
readonly ARGS="$@"

pacman-key --init
pacman-key --populate archlinuxarm

#hostnamectl set-hostname odroid
timedatectl set-timezone Europe/Bucharest
localectl set-locale LANG=en_US.UTF-8

pacman -Syu --noconfirm
pacman -S --noconfirm docker htop sudo vim wget
pacman -S --noconfirm community/tmux community/perf

#request password for sudo operations
echo 'alarm ALL=NOPASSWD: ALL' >/etc/sudoers.d/user-alarm
usermod -aG docker alarm

systemctl enable docker.socket
systemctl enable docker.service
