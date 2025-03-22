# Modifications

<!--toc:start-->
- [Modifications](#modifications)
  - [GRUB](#grub)
  - [Plymouth](#plymouth)
  - [SDDM](#sddm)
  - [Window Manager](#window-manager)
    - [Openbox](#openbox)
    - [Hyprland](#hyprland)
    - [General](#general)
  - [Config files](#config-files)
  - [Terminal](#terminal)
  - [Video player](#video-player)
<!--toc:end-->

List of changes made on the rice.

## GRUB

Custom GRUB theme located on `assets/grub/themes`, retro style.

## Plymouth

Custom Plymouth theme located on `usr/share/lymouth/themes`, based on `arch-logo-new` theme from the AUR. It allows to have a prompt for the LUKS password if you encrypted your disk, the theme [`hellonavi`](https://github.com/yi78/hellonavi) does not.

## SDDM

Theme with [fauux](https://fauux.neocities.org/) art.

## Window Manager

### Openbox

The main WM is `Openbox` and it uses the `tint2` bar.

There is a drop-down terminal, press `F10`.

### Hyprland

The alternative Wayland WM is `Hyprland` and it uses waybar. All cool kids are using it.

### General

- A lot of packages are installed from the AUR.
- Default cursor is StarLabs.
- Default file browser is Thunar.
- Default mail reader is Thunderbird.
- Firefox, Librewolf and Tor are installed.

## Config files

On `etc/skel/.config` there are several config files for some applications, the more relevant are: `alacritty`, `fastfetch`, `fontconfig`, `openbox`, `hypr`, `rofi`, `tint2`, `rofi`. Some packages are specific to Openbox other to Hyprland and some are used in both.

## Terminal

The main terminal emulator is `Alacritty` using `zsh` as shell, all fonts use the [Nerd Symbols Font](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/NerdFontsSymbolsOnly) to extend the available glyphs without need to patch all fonts.

Also `oh-my-zsh` is installed along some plugins.

The default terminal editor is Neovim and different stacks are installed.

Since Alacritty don't have tabs feature included you can use `tmux` to have different sessions and panels. The config is based on [.tmux](https://github.com/gpakosz/.tmux) project.

## Video player

The default video player is `mpv` with a better interface `mpv-uosc`.

The `ani-cli` package is installed.
