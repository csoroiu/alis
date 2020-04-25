#!/bin/bash
readonly PROGNAME=$(basename $0)
readonly PROGDIR=$(readlink -m $(dirname $0))
readonly ARGS="$@"

# https://www.tecmint.com/install-yay-aur-helper-in-arch-linux-and-manjaro/
# install yay
deploy_user=alarm

pacman -S --noconfirm --needed base-devel git
pushd /opt
git clone https://aur.archlinux.org/yay-git.git
chown -R ${deploy_user}:${deploy_user} yay-git
cd yay-git
#execute makepkg as user alarm
sudo -H -u ${deploy_user} makepkg -si --noconfirm
#cleanup unwanted dependencies
sudo -H -u ${deploy_user} yay -Yc --noconfirm
popd
