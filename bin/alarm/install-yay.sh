#!/bin/bash -e
readonly PROGNAME=$(basename "$0")
readonly PROGDIR="$(dirname -- "$(readlink -f -- "$0")")"
readonly ARGS=("$@")

# https://www.tecmint.com/install-yay-aur-helper-in-arch-linux-and-manjaro/
# install yay
deploy_user=alarm

pacman -S --noconfirm --needed base-devel libffi git
pushd /opt
git clone https://aur.archlinux.org/yay-git.git
chown -R ${deploy_user}:${deploy_user} yay-git
cd yay-git
#execute makepkg as user alarm
sudo -H -u ${deploy_user} makepkg -si --noconfirm
#cleanup unwanted dependencies
sudo -H -u ${deploy_user} yay -Yc --noconfirm
#save default settings for yay
#https://forum.manjaro.org/t/how-can-one-set-up-a-cron-job-to-update-with-yay/64725
sudo -H -u ${deploy_user} yay --save --nocleanmenu --nodiffmenu --noeditmenu --noupgrademenu --removemake --cleanafter --norebuild --combinedupgrade --noredownload --useask --nosudoloop --clean
popd
