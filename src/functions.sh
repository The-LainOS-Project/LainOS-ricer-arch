#!/usr/bin/env bash

# WARNING: DON'T JUST RUN. OBSERVE, JUDGE, AMUSE AT YOUR OWN PERIL.

function echo_title() { echo -ne "\033[1;44;37m${*}\033[0m\n"; }
function echo_caption() { echo -ne "\033[0;1;44m${*}\033[0m\n"; }
function echo_bold() { echo -ne "\033[0;1;34m${*}\033[0m\n"; }
function echo_danger() { echo -ne "\033[0;31m${*}\033[0m\n"; }
function echo_success() { echo -ne "\033[0;32m${*}\033[0m\n"; }
function echo_warning() { echo -ne "\033[0;33m${*}\033[0m\n"; }
function echo_s() { echo -ne "\033[0;34m${*}\033[0m\n"; } # secondary
function echo_info() { echo -ne "\033[0;35m${*}\033[0m\n"; }
function echo_p() { echo -ne "\033[0;36m${*}\033[0m\n"; } # primary
function echo_error() { echo -ne "\033[0;1;31merror:\033[0;31m\t${*}\033[0m\n"; }
function echo_label() { echo -ne "\033[0;1;32m${*}:\033[0m\t"; }
function echo_prompt() { echo -ne "\033[0;36m${*}\033[0m "; }

function message() {
	tput setaf "$1"
	echo
	echo "------------------------------------------------------------"
	echo "| > $2"
	echo "------------------------------------------------------------"
	echo
	tput sgr0
}

function category() {
	message 5 "Installing software for category $1"
}

function install() {
	if pacman -Qi "$1" &>/dev/null; then
		tput setaf 2
		echo "The package $1 is already installed"
	else
		pacman -S --noconfirm --needed "$1"
	fi
}

function install_list() {
	count=0
	list=("$@")
	for name in "${list[@]}"; do
		((count++))
		message 3 "$count/${#list[@]}: $name"
		tput sgr0
		install "$name"
	done
}

function help() {
	echo
	echo_p "Description :"
	echo_s "\tThis script helps you to customize a fresh Arch Linux installation to convert it into LainOS. Manual intervention could be needed.\n"
	echo_p "Arguments :"
	echo_s "-h/--help"
	echo_info "\thelp command"
	echo_s "-g"
	echo_info "\tGrub"
	echo_s "-p"
	echo_info "\tPlymouth"
	echo_s "-tf"
	echo_info "\tTest styles of terminal font"
}

function grub_theme() {
	# Run as root
	# sudo ./LainOS-ricer-arch.sh -g
	cp -an /etc/default/grub /etc/default/grub.bak
	mkdir -pv /boot/grub/themes/LainOS
	cp -a ../assets/grub/themes/LainOS/* /boot/grub/themes/LainOS
	# add splash flag
	sed -i '/GRUB_CMDLINE_LINUX_DEFAULT=/d' /etc/default/grub
	sed -i '4a\GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet splash"' /etc/default/grub
	# remove default grub style if any
	sed -i '/GRUB_TIMEOUT_STYLE=/d' /etc/default/grub
	echo 'GRUB_TIMEOUT_STYLE="menu"' >>/etc/default/grub
	# remove default timeout if any
	sed -i '/GRUB_TIMEOUT=/d' /etc/default/grub
	echo 'GRUB_TIMEOUT="13"' >>/etc/default/grub
	# remove theme if any
	sed -i '/GRUB_THEME=/d' /etc/default/grub
	echo "GRUB_THEME=\"/boot/grub/themes/LainOS/theme.txt\"" >>/etc/default/grub
	# remove default timeout if any
	sed -i '/GRUB_GFXMODE=/d' /etc/default/grub
	echo 'GRUB_GFXMODE="auto"' >>/etc/default/grub
	grub-mkconfig -o /boot/grub/grub.cfg
}

function plymouth_hellonavi() {
	# Run as root
	# sudo ./LainOS-ricer-arch.sh -p
	git clone https://github.com/yi78/hellonavi.git
	cp -v ./hellonavi/hellonavi/ /usr/share/plymouth/themes/
	plymouth-set-default-theme -l
	# lainos theme supports prompt for LUKS password
	plymouth-set-default-theme -R lainos # hellonavi
}

function test_font() {
	# Based on: https://cutt.ly/NwhoZM0k
	message 10 "Testing the styles of the current font"
	echo normal
	echo -e '\e[1mbold\e[22m'
	echo -e '\e[2mdim\e[22m'
	echo -e '\e[3mitalic\e[23m'
	echo -e '\e[1;3mbold-italic\e[0m'
	echo -e '\e[4munderline\e[24m'
	echo -e '\e[1;3;4mbold-italic-underline\e[0m'
	echo -e '\e[4:1mthis is also underline (new in 0.52)\e[4:0m'
	echo -e '\e[21mdouble underline (new in 0.52)\e[24m'
	echo -e '\e[4:2mthis is also double underline (new in 0.52)\e[4:0m'
	echo -e '\e[4:3mcurly underline (new in 0.52)\e[4:0m'
	echo -e '\e[5mblink (new in 0.52)\e[25m'
	echo -e '\e[7mreverse\e[27m'
	echo -e '\e[8minvisible\e[28m <- invisible (but copy-pasteable)'
	echo -e '\e[9mstrikethrough\e[29m'
	echo -e '\e[53moverline (new in 0.52)\e[55m'
	echo -e "LainOS special glyphs: \uf3fe  -  \uf3ff"
	echo
}
