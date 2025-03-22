# After installation tips

<!--toc:start-->
- [After installation tips](#after-installation-tips)
  - [Localization](#localization)
    - [Keyboard layout](#keyboard-layout)
    - [Language](#language)
  - [Themes](#themes)
  - [Default applications](#default-applications)
  - [Familiarize with the shortcuts](#familiarize-with-the-shortcuts)
<!--toc:end-->

List of things you may want to change.

## Localization

If you haven't configured your keyboard and language.

### Keyboard layout

If the layout of your keyboard don't match the X11 settings:

- View current settings

    ```shell
    setxkbmap -print -verbose 10 # or
    localectl
    ```

- Check available settings

    ```shell
    localectl list-x11-keymap-models
    localectl list-x11-keymap-layouts
    localectl list-x11-keymap-variants [layout]
    localectl list-x11-keymap-options
    ```

- You can change the settings for your current X session

    ```shell
    setxkbmap -model pc105 -layout latam -variant deadtilde
    ```

- You can make permanent changes changing the X11 config files with:

    ```shell
    localectl --no-convert set-x11-keymap latam pc105 deadtilde
    ```

Any previous change can be overwritten by other tools like `fcitx5`.

### Language

- Uncomment the locales on `/etc/locale.gen` file that you want to be available.
- Run

 ```shell
 sudo locale-gen
 ```

- Edit `/etc/locale.conf` file to set the language, you can set multiple variables.

 ```/etc/locale.conf
 LANG="es_MX.UTF-8"
 LC_CTYPE='en_US.UTF-8'
 LC_MESSAGES='en_US.UTF-8'
 LC_TIME='ja_JP.UTF-8'
 ```

## Themes

You can change the color, cursor and icon themes opening the `lxappearance` program.

## Default applications

If you don't like the default applications open the Xfce `Default Applications` program and you'll be able to change the defaults of: web browser, mail reader, file manager and terminal emulator.

## Familiarize with the shortcuts

Table with some relevant shortcuts. Other shortcuts for media, volume and brightness are also configured.

| Keyboard shortcut  |               Action                | Openbox | Hyprland |
| ------------------ | ----------------------------------- | :-----: | :------: |
| Super + Shift + R  | Reconfigure Openbox                 |    X    |          |
| Super + Shift + B  | Restart waybar                      |         |    X     |
| Super + Q          | Quit program                        |    X    |    X     |
| Super + Space      | Launch Rofi/Wofi                    |    X    |    X     |
| Ctrl + Alt + K     | Launch screenlock/wlogout           |    X    |    X     |
| Ctrl + Alt + L     | Launch screenlock/wlogout           |    X    |    X     |
| Super + X          | Launch screenlock/wlogout           |    X    |    X     |
| Super + H          | Launch htop                         |    X    |          |
| Super + H          | Scratchpad to SSH to home-server    |         |    X     |
| Super + W          | Default web browser                 |    X    |    X     |
| Super + M          | Default mail reader                 |    X    |    X     |
| Super + F          | Default file manager                |    X    |    X     |
| Super + T          | Default terminal emulator           |    X    |    X     |
| Ctrl + Alt + Enter | Default terminal emulator           |    X    |    X     |
| Ctrl + Alt + T     | alacritty -e tmux                   |    X    |    X     |
| Ctrl + Alt + O     | Toggle picom                        |    X    |          |
| Super + Esc        | xkill                               |    X    |          |
| F10                | Toggle dropdown terminal            |    X    |          |
| Alt + R            | Resize window                       |    X    |          |
| Ctrl + Alt + Left  | Move to desktop left                |    X    |          |
| Ctrl + Alt + Right | Move to desktop right               |    X    |          |
| Super + C          | Launch FreeCAD                      |    X    |    X     |
| Super + E          | Launch Element                      |    X    |    X     |
| Super + G          | Launch Telegram                     |    X    |    X     |
| Super + K          | Launch KiCad                        |    X    |    X     |
| Super + O          | Launch Lollypop                     |    X    |    X     |
| Super + U          | Launch Tutanota                     |    X    |    X     |
| Super + A          | Scratchpad terminal                 |         |    X     |
| Super + B          | Scratchpad btop                     |         |    X     |
| Super + V          | Clipboard history                   |         |    X     |
| Super + Z          | Zoom ++                             |         |    X     |
| Super + Shift + Z  | Zoom 1.5/reset                      |         |    X     |
| Super + F2         | Launch gmrun                        |    X    |    X     |
| Alt + F2           | Launch gmrun                        |    X    |    X     |
| Alt + T            | variety trash wallpaper             |    X    |    X     |
| Alt + N            | variety next wallpaper              |    X    |    X     |
| Alt + P            | variety previous wallpaper          |    X    |    X     |
| Alt + F            | variety favorite wallpaper          |    X    |    X     |
| Print              | Take screenshot                     |    X    |    X     |
| Ctrl + Print       | Take fullscren screenshot           |    X    |    X     |
| Alt + Print        | Wait and take screenshot            |    X    |    X     |
| Super + Shift + C  | Colorpicker HTML                    |    X    |    X     |
| Super + Ctrl + C   | Colorpicker RGB                     |    X    |    X     |
| Super + n          | Move to workspace n                 |         |    X     |
| Ctrl + Alt + n     | Move window to workspace n          |         |    X     |
| Super + Alt + n    | Move window to workspace n silently |         |    X     |
