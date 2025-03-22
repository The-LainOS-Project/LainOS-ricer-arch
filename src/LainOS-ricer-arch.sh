#!/usr/bin/env bash

# ---------------------------------------------------------------------------
#
# Script to automate (as much as possible) LainOS ricing starting from a
# fresh install of Arch Linux.
#
# The idea is to run this script just after making your Arch install.
#
# Read the scripts before running them.
#
# Created by hasecilu & LainOS team
# 		based on ArcoLinuxD-openbox scripts by Erik Dubois
#
# NAME: LainOS ricer 4 Arch,  Part 1: root user
# VERSION: 0.7
#
# ---------------------------------------------------------------------------

# WARNING: DON'T JUST RUN. OBSERVE, JUDGE, AMUSE AT YOUR OWN PERIL.

if [ "${PWD##*/}" != "src" ]; then
	function echo_error() { echo -ne "\033[0;1;31merror:\033[0;31m\t${*}\033[0m\n"; }
	echo_error "The working directory must be 'src'."
	exit 1
else
	source functions.sh
	if [ $# -eq 0 ]; then
		if [ "$EUID" -ne 0 ]; then
			echo_error "Please run as root."
			echo
			exit
		else
			./1_desktop.sh
			./2_software.sh
			./3_0_config.sh
		fi
	elif [ $# -eq 1 ]; then
		if [[ "$1" = "-g" ]]; then
			grub_theme
		elif [[ "$1" = "-p" ]]; then
			plymouth_hellonavi
		elif [[ "$1" = "-tf" ]]; then
			test_font
		else
			help
		fi
	else
		help
	fi
fi
