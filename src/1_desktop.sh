#!/usr/bin/env bash

# WARNING: DON'T JUST RUN. OBSERVE, JUDGE, AMUSE AT YOUR OWN PERIL.

source functions.sh

# Preparation ##################################################################

pacman -Syyu
pacman -S --noconfirm --needed pacman-contrib

cp ../etc/pacman.conf /etc/
#cp -r ../etc/pacman.d/ /etc/

message 6 "Ranking mirrors"
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist.backup
rankmirrors -n 10 /etc/pacman.d/mirrorlist.backup >/etc/pacman.d/mirrorlist

pacman -Sy

# Desktop environment ##########################################################

message 6 "Installation of the core software"
message 7 "Openbox / X.org"
# NOTE: Check what video driver you need, add it and
# check for extra configurations

# xf86-video-amdgpu
install_list linux-firmware mesa openbox plymouth sddm xorg-server \
	gnome-keyring qt5ct qt5-multimedia qt5-quickcontrols qt6ct zsh

echo_s "Enabling sddm as display manager"
systemctl enable sddm.service

message 14 "Hyprland / Wayland"
install_list hypr{idle,land,lock,picker} wofi \
	nwg-look uwsm waybar swaybg dunst \
	xdg-desktop-portal-wlr grim slurp \
	cliphist wl-clipboard wl-clip-persist \
	pamixer swappy cpio

# Sound ########################################################################

message 6 "Choose pulseaudio or pipewire to have sound"
echo_p "Make your choice:"
echo
echo_s "0.  Do nothing"
echo_s "1.  Pulseaudio"
echo_s "2.  Pipewire"
echo

list=()
read -r CHOICE
case $CHOICE in
0) echo_p "We did nothing as per your request\n" ;;
1) list=(
	pulseaudio{,-alsa}
	pavucontrol alsa-{firmware,lib,plugins,utils}
	gstreamer gst-plugins-{base,bad,good,ugly} playerctl volumeicon
) ;;
2) list=(
	pipewire{,-pulse,-alsa,-jack,-zeroconf}
	pavucontrol alsa-{firmware,lib,plugins,utils}
	gstreamer gst-plugins-{base,bad,good,ugly} playerctl volumeicon
) ;;
*) echo_danger ">:v\n" ;;
esac
install_list "${list[@]}"

# Bluetooth ####################################################################

message 6 "Installation of bluetooth software"
install_list pulseaudio-bluetooth bluez{,-libs,-utils} blueberry

echo_s "Enabling bluetooth service"

systemctl enable --now bluetooth.service
# sed -i 's/' #AutoEnable=false'/'AutoEnable=true'/g' /etc/bluetooth/main.conf

# Printers #####################################################################

message 6 "Installation of printer software"
install_list cups cups-pdf ghostscript gsfonts gutenprint gtk3-print-backends \
	libcups system-config-printer

echo_s "Enabling cups service"

systemctl enable --now cups.service

# Samba ########################################################################

message 6 "Installation of samba software"
install_list samba cifs-utils gvfs-smb

# echo_s "Give your username for samba"
#
#
# read -p "What is your login? It will be used to add this user to smb : " choice
# smbpasswd -a $choice

# echo_s "Enabling services"
#
# systemctl enable smb.service
# systemctl enable nmb.service

# Laptop #######################################################################

message 6 "Installation of laptop software"

list=(tlp)

echo -e "\n\n"
read -p "Is this device a laptop? [y/N] : " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
	echo
	install_list "${list[@]}"
	echo "Enabling services"
	systemctl enable tlp.service
	echo "Software has been installed"
else
	echo -e "\nLaptop programs are not being installed"
fi

# Network ######################################################################

message 6 "Installation of network software"
install_list avahi nss-mdns openresolv wireguard-tools

echo_s "Enabling services"
systemctl enable avahi-daemon.service
