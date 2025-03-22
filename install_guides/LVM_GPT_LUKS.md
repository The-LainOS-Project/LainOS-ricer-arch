# Arch Linux installation guide LVM+GPT+LUKS

<!--toc:start-->
- [Arch Linux installation guide LVM+GPT+LUKS](#arch-linux-installation-guide-lvmgptluks)
  - [Preparation](#preparation)
    - [Setup the computer](#setup-the-computer)
    - [Get the Arch ISO](#get-the-arch-iso)
  - [Boot](#boot)
  - [Get Internet access](#get-internet-access)
    - [Ethernet cable](#ethernet-cable)
    - [Wi-Fi](#wi-fi)
  - [Identification of partitions](#identification-of-partitions)
  - [Partition the disks](#partition-the-disks)
    - [Generate fstab file](#generate-fstab-file)
  - [Installation](#installation)
    - [Installation of packages and configuration](#installation-of-packages-and-configuration)
  - [GRUB](#grub)
    - [Set up GRUB to be able to unlock the disk](#set-up-grub-to-be-able-to-unlock-the-disk)
  - [Test installation](#test-installation)
  - [Post installation](#post-installation)
    - [Create a swap file](#create-a-swap-file)
    - [Set time zone](#set-time-zone)
    - [Set the hostname](#set-the-hostname)
    - [Install more stuff](#install-more-stuff)
    - [Configure plymouth](#configure-plymouth)
    - [Config files](#config-files)
    - [Create users](#create-users)
<!--toc:end-->

This case creates `LVM` partitions with LUKS encryption on a `GPT` table.

## Preparation

Setup the computer and some settings in the live enviroment.

### Setup the computer

- Backup any previous data from the disk.
- In the motherboard `BIOS` settings, set the boot mode to `UEFI`.

### Get the Arch ISO

- Download the iso image: [Arch Linux - Downloads][01]
- Create a bootable USB

    ```shell
    sudo dd bs=4M if=/home/user/archlinux-2024.06.01-x86_64.iso of=/dev/sdd conv=fdatasync status=progress
    ```

## Boot

- Boot into the live system, you may need to press a special key to get into the boot options.
- Change keymap to have the correct keys of your keyboard mapped.
  - List available keymaps

    ```shell
    ls /usr/share/kbd/keymaps/**/*.map.gz | grep [es/la-latin1]
    ```

  - Choose a keymap

    ```shell
    loadkeys la-latin1
    ```

- If the font is not readable change it to a bigger font, it's temporary for the session.
  - List available fonts

    ```shell
    ls /usr/share/kbd/consolefonts | less
    ```

  - Change font

    ```shell
    setfont ter-132b ## Biggest font
    setfont ter-v20b
        ```

- Verify boot mode

    ```shell
    ls /sys/firmware/efi/efivars
    ## or
    cat /sys/firmware/efi/fw_platform_size
    ```

  - **NOTE: If the command returns 64, then system is booted in UEFI mode and has a 64-bit x64 UEFI. If the command returns 32, then system is booted in UEFI mode and has a 32-bit IA32 UEFI; while this is supported, it will limit the boot loader choice to GRUB. If the file does not exist, the system may be booted in BIOS (or CSM) mode. If the system did not boot in the mode you desired (UEFI vs BIOS), refer to your motherboard's manual.**

## Get Internet access

### Ethernet cable

- You are done

### Wi-Fi

- Open the internt wireless control utility, a new shell will open.

    ```shell
    iwctl
    ```

- Check the name of the Wi-Fi adapters

    ```shell
    device list ## View Wi-Fi adapters, ex: `wlan0`
    ```

  - **NOTE: The table of the `Powered` property of the device must be `on`, if it's not close the shell  and run `rfkill unblock all`, then run `iwctl` and then `device list` to confirm the change.**
- Find the Wi-Fi networks using the name of the device, example: `wlan0`

    ```shell
    station wlan0 scan ## Trigger the search
    station wlan0 get-networks ## View available networks
    station wlan0 connect "Name of the Network" ## Connect to Wi-Fi
    ## Type password and close the shell
    quit
    ```

- Test internet connection

    ```shell
    ip addr show
    ping -c 10 archlinux.org
    ```

- Update system clock

    ```shell
    timedatectl set-ntp true
    timedatectl set-timezone America/Mexico_City
    timedatectl
    ```

## Identification of partitions

- Identify partitions on disk to avoid format important data!

    ```shell
    fdisk -l
    ```

- If you need to delete some partitions do this:
  - Start the partitioner `fdisk`

    ```shell
    fdisk /dev/<DEVICE> ## (substitute <DEVICE> for your device name, example: /dev/sda or /dev/nvme0n1)
    ```

  - To delete partition, run the `d` command in the `fdisk` command-line utility.
  - Then select the number of the partition that you want to delete.
  - Run the `p` command in the `fdisk` command-line utility to confirm that the changes are as expected.
  - Run the `w` command to write the changes.

The next step is to create the `GPT` table partitions, you can use `fdisk`, `cfdisk`, `gfdisk`, `dgfdisk`, etc. Depending on the type of your desired installation you may need a different partition scheme, get informed!

## Partition the disks

We will use `sgdisk`, this command is script compatible.

- Run next `sgdisk` command

    ```shell
    sgdisk --clear \
    --new=1::+512M --typecode=1:ef00 --change-name=1:"EFI System Partition" \
    --new=2::+512M --typecode=2:8300 --change-name=2:"Linux Filesystem" \
    --new=3 --typecode=3:8e00 --change-name=3:"Linux LVM" \
    /dev/<DEVICE>
    ```

- Format the EFI partition

    ```shell
    mkfs.fat -F32 /dev/<DEVICE PARTITION 1> # for example: /dev/sda1
    ```

- Format the boot partition

    ```shell
    mkfs.ext4 /dev/<DEVICE PARTITION 2> # for example: /dev/sda2
    ```

- Set up encryption

    ```shell
    cryptsetup luksFormat /dev/<DEVICE PARTITION 3>
    cryptsetup open --type luks /dev/<DEVICE PARTITION 3> lvm
    ```

- Set up LVM

    ```shell
    pvcreate --dataalignment 1m /dev/mapper/lvm
    vgcreate volgroup0 /dev/mapper/lvm
    lvcreate -L 30GB volgroup0 -n lv_root
    mount --mkdirlvcreate -L 250GB volgroup0 -n lv_home # or instead of "-L 250GB", use "-l 100%FREE" to use all the remaining space
    modprobe dm_mod
    vgscan
    vgchange -ay
    ```

- Format the root partition

    ```shell
    mkfs.ext4 /dev/volgroup0/lv_root
    ```

- Mount the root partition

    ```shell
    mount /dev/volgroup0/lv_root /mnt
    ```

- Mount the boot partition

    ```shell
    mount --mkdir /dev/<DEVICE PARTITION 2> /mnt/boot
    ```

- Format the home partition

    ```shell
    mkfs.ext4 /dev/volgroup0/lv_home
    ```

- Mount the home volume

    ```shell
    mount --mkdir /dev/volgroup0/lv_home /mnt/home
    ```

### Generate fstab file

- Create the `/etc` directory

    ```shell
    mkdir /mnt/etc
    ```

- Create the `/etc/fstab` file

    ```shell
    genfstab -U -p /mnt >> /mnt/etc/fstab
    ```

- Check the `/etc/fstab` file

    ```shell
    cat /mnt/etc/fstab
    ```

## Installation

After creating the partitions let's continue with the installation.

### Installation of packages and configuration

- Install Arch Linux base packages

    ```shell
    pacstrap -i /mnt base ## base is package group
    ```

- Access the in-progress Arch installation

    ```shell
    arch-chroot /mnt
    ```

- Install a kernel and headers

    ```shell
    pacman -S linux linux-zen linux-headers linux-zen-headers
    ```

- Install a text editor and optional packages

    ```shell
    pacman -S neovim base-devel git openssh
    ```

  - Enable OpenSSH if you’ve installed it

    ```shell
    systemctl enable sshd
    ```

- Install packages for networking and dialog (required for wifi-menu)

    ```shell
    pacman -S networkmanager wpa_supplicant wireless_tools netctl dialog
    ```

  - Enable networkmanager

    ```shell
    systemctl enable NetworkManager
    ```

- Add `LVM` support, used regardless used method

    ```shell
    pacman -S lvm2
    ```

- Edit `/etc/mkinitcpio.conf` file

    ```shell
    nvim /etc/mkinitcpio.conf
    ```

  - On the *HOOKS* line, add support for lvm2 and optionally encryption.
    - Unencrypted hard disk:
      - Add `lvm2` in between `block` and `filesystems`
    - Encrypted hard disk:
      - Add `encrypt lvm2` in between `block` and `filesystems`
  - It should look similar to the following (don’t copy this line in case they change it, but just add the required new items):

    ```
    HOOKS=(base udev autodetect modconf block encrypt lvm2 filesystems keyboard fsck)
    ```

- Create the initial ramdisk for the main kernel

    ```shell
    mkinitcpio -p linux
    ```

- Create the initial ramdisk for the zen kernel (if you installed it), alternatively you can use the zen kernel

    ```shell
    mkinitcpio -p linux-zen
    ```

- Uncomment the line from the  `/etc/locale.gen` file that corresponds to your locale

    ```shell
    nvim /etc/locale.gen ## uncomment en_US.UTF-8, es_MX.UTF-8
    ```

- Generate the locale

    ```shell
    locale-gen
    ```

- Set the root password

    ```shell
    passwd
    ```

The next step s to create the `GRUB` menu, it's a little different for each method!

## GRUB

- Install the required packages for GRUB:

    ```shell
    pacman -S grub efibootmgr dosfstools os-prober mtools
    ```

- Mount the EFI partition:

    ```shell
    mount --mkdir /dev/<DEVICE PARTITION 1> /boot/EFI
    ```

- Install GRUB:

    ```shell
    grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck
    ```

- Create the locale directory for GRUB

    ```shell
    mkdir -pv /boot/grub/locale
    ```

- Copy the locale file to locale directory

    ```shell
    cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo
    ```

### Set up GRUB to be able to unlock the disk

- Open the defaulg config file for GRUB:

    ```shell
    nvim /etc/default/grub
    ```

- Uncomment:

    ```shell
    GRUB_ENABLE_CRYPTODISK=y
    ```

- Add *cryptdevice=<PARTUUID>:volgroup0* to the *GRUB_CMDLINE_LINUX_DEFAULT* line If using standard device naming, the option will look similar this (be sure to adjust the device name):

    ```shell
    cryptdevice=/dev/sda3:volgroup0:allow-discards quiet
    ```

- Generate GRUB’s config file

    ```shell
    grub-mkconfig -o /boot/grub/grub.cfg
    ```

## Test installation

All needed packages and configs are already installed, now the system should work on reboot.

- Check the `/etc/fstab` file to make sure it includes all the right partitions

 ```shell
 cat /etc/fstab
 ```

- You should have a mountpoint for all of the partitions that were created.

- Moment of truth: Reboot your machine
  - Exit the chroot environment

  ```shell
  exit
  ```

  - Unmount everything (some errors are okay here)

  ```shell
  umount -a
  ```

  - Reboot the machine

  ```shell
  reboot
  ```

  - Now you should be able to log into the root/user account

## Post installation

Now that we know the system is working we can finish tweaking the system.

### Create a swap file

- Log-in as root and create the swapfile

    ```shell
    su
    dd if=/dev/zero of=/swapfile bs=1M count=2048 status=progress
    chmod 600 /swapfile
    mkswap /swapfile
    ```

- Update `/etc/fstab` file

    ```shell
    cp /etc/fstab /etc/fstab.bak
    echo '/swapfile none swap sw 0 0' | tee -a /etc/fstab
    free -m
    swapon -a
    free -m
    ```

### Set time zone

- List time zones:

    ```shell
    timedatectl list-timezones
    ```

- Set your time zone:

    ```shell
    timedatectl set-timezone America/Mexico_City
    ```

- Enable time synchronization via systemd:

    ```shell
    systemctl enable systemd-timesyncd
    ```

### Set the hostname

- Consider setting the hostname of your new installation. You can do so with the following command

    ```shell
    hostnamectl set-hostname myhostname
    ```

- Also, make the same change in `/etc/hosts`

    ```shell
    nvim /etc/hosts
    ```

  - Example lines to add

    ```shell
    127.0.0.1 localhost
    127.0.1.1 myhostname
    ```

### Install more stuff

- Install CPU Microde files (AMD/Intel CPU)

    ```shell
    pacman -S [amd-ucode/intel-ucode]
    ```

- Install Xorg if you plan on having a GUI

    ```shell
    pacman -S xorg-server
    ```

- Install 3D support for Intel or AMD graphics
- If you have an Intel or AMD GPU, install the mesa package:

    ```shell
    pacman -S mesa
    ```

- Install Nvidia Driver packages if you have an Nvidia GPU

    ```shell
    pacman -S nvidia nvidia-utils
    ```

  - **Install nvidia-lts if you’ve installed the LTS kernel**

    ```shell
    pacman -S nvidia-lts
    ```

- Install Virtualbox guest packages
  - If you’re installing Arch inside a Virtualbox virtual machine, install these packages:

    ```shell
    pacman -S virtualbox-guest-utils xf86-video-vmware
    ```

### Configure plymouth

- Add `plymouth` to the `HOOKS` array in [mkinitcpio.conf](https://wiki.archlinux.org/title/Mkinitcpio.conf).

    ```shell
    nvim /etc/mkinitcpio.conf
    ```

  - After `base` and `udev`, example:
    - `HOOKS=(base udev plymouth autodetect modconf kms keyboard keymap consolefont block encrypt lvm2 filesystems fsck)`
  - Update the boot for every kernel you have: `linux`, `linux-lts`, `linux-zen`

    ```shell
    mkinitcpio -p linux-zen ## root
    ```

- Install a theme
- Change the theme

    ```shell
    git clone https://github.com/yi78/hellonavi.git
    cp -rv ./hellonavi/hellonavi/ /usr/share/plymouth/themes/
    plymouth-set-default-theme -l
    plymouth-set-default-theme -R hellonavi
    ```

- If you want to see the splash screen, append `splash` to the [kernel parameters](https://wiki.archlinux.org/title/Kernel_parameters).
  - Edit `/etc/default/grub` and append your kernel options between the quotes in the `GRUB_CMDLINE_LINUX_DEFAULT` line:

    ```
    GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet splash"
    ```

  - If you have another OS installed you need to enable `os-prober`, line below must be uncommented.

    ```
    GRUB_DISABLE_OS_PROBER=false
    ```

  - And then automatically re-generate the `grub.cfg` file with:

    ```shell
    grub-mkconfig -o /boot/grub/grub.cfg ## root
    ```

  - Confirm your theme is selected

    ```shell
    cat /etc/plymouth/plymouthd.conf
    ```

### Config files

- Copy all user config files to `/etc/skel` directory
- Set up samba shares
- Use a post-install script to install more programs, color themes, icons, etc.
  - Use the `LainOS-ricer-arch` script

    ```shell
    git clone https://codeberg.org/LainOS/LainOS-ricer-arch.git
    ```

  - Change to `src` directory and execute the `LainOS-ricer-arch.sh` script

    ```shell
    cd LainOS-ricer-arch/src
    ./LainOS-ricer-arch.sh
    ```

### Create users

- Create a user for yourself, it's better to not do it before setting the `/etc/skel` directory

    ```shell
    useradd -m -g users -G sddm video wheel <username>
    ```

- Set your password

    ```shell
    passwd <username>
    ```

- Allow users in the `wheel` group to use `sudo`

    ```shell
    EDITOR=nvim visudo
    ```

- Uncomment this line:

    ```shell
    %wheel ALL=(ALL) ALL
    ```

[01]: https://archlinux.org/download/
