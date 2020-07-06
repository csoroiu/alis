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
pacman -S --noconfirm bash-completion
#pacman -S --noconfirm playerctl
pacman -S --noconfirm usbutils
#device tree compiler
pacman -S --noconfirm dtc
#pacman -S --noconfirm raspberrypi-userland-aarch64-git

#request password for sudo operations
echo 'alarm ALL=NOPASSWD: ALL' >/etc/sudoers.d/user-alarm
gpasswd -a alarm docker

systemctl enable docker.socket
systemctl enable docker.service
