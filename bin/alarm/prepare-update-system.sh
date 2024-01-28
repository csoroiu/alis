#!/bin/bash
readonly PROGNAME=$(basename "$0")
readonly PROGDIR="$(dirname -- "$(readlink -f -- "$0")")"
readonly ARGS=("$@")

pacman-key --init
pacman-key --populate archlinuxarm

#hostnamectl set-hostname odroid
timedatectl set-timezone Europe/Bucharest
locale-gen
localectl set-locale LANG=en_US.UTF-8

pacman -Syu --noconfirm

#install sudo
pacman -S --noconfirm sudo
#request password for sudo operations
echo 'alarm ALL=NOPASSWD: ALL' >/etc/sudoers.d/user-alarm

#install utilities
pacman -S --noconfirm htop vim wget
pacman -S --noconfirm community/tmux community/perf
pacman -S --noconfirm bash-completion
#pacman -S --noconfirm playerctl
pacman -S --noconfirm usbutils
#device tree compiler
pacman -S --noconfirm dtc uboot-tools
#pacman -S --noconfirm linux-rpi
#pacman -S --noconfirm rpi4-eeprom
#pacman -S --noconfirm rpi5-eeprom

#containerd and runc
pacman -S --noconfirm containerd #which uses runc

#docker stuff
#pacman -S --noconfirm docker
#gpasswd -a alarm docker
#systemctl enable docker.socket
#systemctl enable docker.service
