#!/usr/bin/env bash

# WARNING: DON'T JUST RUN. OBSERVE, JUDGE, AMUSE AT YOUR OWN PERIL.

source functions.sh

# Directories in $HOME directory
xdg-user-dirs-update
mkdir -p "$HOME"/Pictures/Screenshots

# For urxvt
xrdb -load "$HOME"/.Xresources

category Neovim
echo_p "Install some popular Neovim configuration stacks"

read -p "Do you want to install Neovim distributions? [y/N] : " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
	echo
	echo_p "Installing kickstart"
	git clone https://github.com/nvim-lua/kickstart.nvim.git "$HOME"/.config/kickstart
	echo_p "Installing LazyVim"
	git clone https://github.com/LazyVim/starter "$HOME"/.config/LazyVim
	echo_p "Copying some extra files for LazyVim"
	cp -r ../assets/LazyVim/lua "$HOME"/.config/LazyVim
	echo_p "Installing AstroNvim"
	git clone --depth 1 https://github.com/AstroNvim/AstroNvim "$HOME"/.config/AstroNvim
fi

category oh-my-zsh
echo_p "Install some popular plugins for oh-my-zsh"

read -p "Do you want to install zsh plugins? [y/N] : " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
	echo

	# Install oh-my-zsh
	echo_p "Installing oh-my-zsh"
	ZSH="$HOME"/.local/share/oh-my-zsh sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	sed -i 's:$HOME/.oh-my-zsh:$HOME/.local/share/oh-my-zsh:' ~/.zshrc

	# Install power-level-10k
	echo_p "Installing power-level-10k"
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
		"${ZSH_CUSTOM:-$HOME/.local/share/oh-my-zsh/custom}"/themes/powerlevel10k
		sed -i '/ZSH_THEME=/d' ~/.zshrc
		sed -i '28a\ZSH_THEME="powerlevel10k/powerlevel10k"' ~/.zshrc
		sed -i 's/ fd//' ~/.zshrc
		sed -i 's/ ripgrep//' ~/.zshrc

	# Install zsh-syntax-highlighting
	echo_p "Installing zsh-syntax-highlighting"
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
		"${ZSH_CUSTOM:-$HOME/.local/share/oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting

	# Install zsh-autosuggestions
	echo_p "Installing zsh-autosuggestions"
	git clone https://github.com/zsh-users/zsh-autosuggestions \
		"${ZSH_CUSTOM:-$HOME/.local/share/oh-my-zsh/custom}"/plugins/zsh-autosuggestions
fi

git clone https://github.com/junelva/wl-gammarelay-applet.git
cd wl-gammarelay-applet || return
cargo build --release
ln -s "$(pwd)"/target/release/wl-gammarelay-applet ~/.local/bin/wl-gammarelay-applet

category "Installing paru"

# Install paru
git clone https://aur.archlinux.org/paru.git "$HOME"/paru
cd "$HOME"/paru || return
makepkg -si

category "Install packages from the AUR"
# Packages from the AUR, easier to install with an AUR helper with a non-root user
paru -S --noconfirm --needed ani-cli c-lolcat gowall gpa kloak-git \
	librewolf-bin light mpv-{thumbfast-git,uosc} obmenu-generator perl-linux-desktopfiles pyprland \
 	tdrop tor-browser wlogout wl-gammarelay-rs \
	xdg-ninja zenmap

category "Install fonts from the AUR"
paru -S --noconfirm --needed 3270-fonts ttf-{agave,envy-code-r,victor-mono}

ln -s /usr/share/mpv/fonts "$HOME"/.config/mpv/
ln -s /usr/share/mpv/scripts/uosc "$HOME"/.config/mpv/scripts/
ln -s /usr/share/mpv/script-opts/uosc.conf "$HOME"/.config/mpv/script-opts/

# Block add domains
hblock

# Generate openbox menu
obmenu-generator -p -i -u
