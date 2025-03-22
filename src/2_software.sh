#!/usr/bin/env bash

# WARNING: DON'T JUST RUN. OBSERVE, JUDGE, AMUSE AT YOUR OWN PERIL.

source functions.sh

# User applications ############################################################

category Android
# universal-android-debloater (AUR)
install_list android-tools gvfs-gphoto2 gvfs-mtp mtpfs

category Development
# gnome-boxes meld
install_list archiso base-devel entr gdb git git-delta indent jq lazygit \
	man-pages neovim nix onefetch python-{pip,pynvim,setuptools,virtualenv} \
	shellcheck valgrind

category Programming
install_list clang clisp gcc go npm python rust

category Fonts
install_list gnome-font-viewer otf-cascadia-code terminus-font ttc-iosevka \
	noto-fonts-{cjk,emoji} \
	ttf-{droid,nerd-fonts-symbols,fira-code,hack,inconsolata}

category Games
# 0ad steam
install_list supertux supertuxkart

category Graphics
# scour
install_list gimp inkscape loupe

category Multimedia
install_list lollypop mpv{,-mpris} snapshot vlc

category Hacking
# kloak & zenmap on 3_1_user.sh script
install_list bettercap nmap sqlmap wireshark-qt kismet wifite metasploit hashcat

category Internet
# deluge deluge-gtk librewolf
install_list firefox

category Communication
install_list discord element-desktop telegram-desktop thunderbird

category Office
install_list evince libreoffice-fresh

category Privacy/Security
# Librewolf, gpa, and Tor on 3_1_user.sh script
install_list firejail gufw hblock keepassxc macchanger

category Terminal utilities
install_list alacritty asciinema bat broot btop chafa curl duf dust eza fastfetch \
	fd ffmpeg fzf htop man-db perl-{image-exiftool,rename} procs rclone ripgrep \
	rsync scrot sqlite tldr tmux vnstat wget xdg-user-dirs xsel yt-dlp zoxide

systemctl enable --now vnstat

category Terminal games
install_list asciiquarium cmatrix cowsay figlet sl

category Themes
install_list breeze breeze-gtk

category Unpack
install_list cabextract file-roller unace unrar zip unzip sharutils uudeview arj p7zip

category Desktop utilities
# onthespot-git spicetify-cli dialect
install_list arandr baobab dconf-editor gmrun gsimplecal gtk2-perl gtk-engine-murrine \
	imagemagick lxappearance lxappearance-obconf lxrandr nitrogen obconf \
	picom playerctl rofi rofi-calc tint2 \
	variety xorg-xbacklight xorg-xkill xorg-xrdb

# ArcoLinux ####################################################################

category ArcoLinux
# arcolinux-openbox-themes-git
# arcolinux-tint2-themes-git
# arcolinux-pipemenus-git
# arcolinux-common-git
# arcolinux-xfce-git
# arcolinux-local-xfce4-git
# arcolinux-bin-git
# archlinux-logout-git
install_list xfce4-{clipman-plugin,power-manager,screenshooter,settings,taskmanager} \
	thunar{,-archive-plugin,-volman}
