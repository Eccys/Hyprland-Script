<div align="center">

# 💥 **Hyprland Install Script for Arch Linux** 💥
<br>

</div>

    
## Welcome to the best Hyprland installer script for Arch Linux.
- This repository does not include any configuration files. Configuration files can be found [here](https://github.com/Eccys/dotfiles). If you choose to use premade configuration files, they will be downloaded from that centralized repo.
- The configuration files are constantly evolving and improving. View latest changes by clicking [here](https://github.com/Eccys/dotfiles/commits/main/) 
- The wallpapers used are available [here](https://github.com/Ecys/Wallpapers)

> [!IMPORTANT]
> install a backup tool like [snapper](https://wiki.archlinux.org/title/snapper) or [timeshift](https://wiki.archlinux.org/title/Timeshift) and back up your system before installing hyprland using this script. This script does NOT include uninstallation of packages. An uninstallation script is not provided, as some packages maybe already installed, and removing them may result in an unrecoverable system. 

> [!WARNING] 
> You must download and use this script in a directory wherein you have permission to write in. Else, the script will fail. 

### 🆕 Prerequisites
- A minimal Arch Linux installation
- An internet connection
- [git](https://wiki.archlinux.org/title/git)

> Notes regarding pipewire and pulseaudio
- This script will install pipewire and disable pulseaudio. If you dont want such behavior, edit install.sh and comment the line  `execute_script "pipewire.sh"`, or delete pipewire.sh in the install-scripts directory prior to installation.

### ✨ Customize which packages to install
- Inside the install-scripts folder, you can edit 00-hypr-pkgs.sh.

### 👀 For NVIDIA users
- By default, nvidia-dkms (supports GTX 900 and newer) will be installed. If you require another driver, edit the nvidia.sh in the install-scripts directory.
> [!IMPORTANT]
> If you wish to use nouveau's drivers, choose N when prompted to install nvidia drivers. Else, the nvidia installer will blacklist nouveau. Hyprland will still be installed, but it will not blacklist nouveau.

## ✨ How to use this script
> Clone this repository.
> Change your directory.
> Make `install.sh` executable.
> Run `install.sh`.

```bash
git clone --depth=1 https://github.com/JaKooLit/Arch-Hyprland.git ~/Hyprland-Script
cd ~/Hyprland-Script
chmod +x install.sh
./install.sh
```

<p align="center">

#### ✨ Installing fish and oh-my-fish
> The installer will auto change your default shell to fish. However, if it does not, do this to change your shell.
```bash
chsh -s $(which fish)
fish
```
- Reboot or logout and log back in to see changes.

### ✨ Post Installation
- If you chose to install GTK themes, press the icon near the padlock to enable them. To apply the Bibata modern ice cursor, launch nwg-look (GTK Settings) through rofi. The initial boot file will attempt to apply GTK themes, cursors, and icons, but you can customize it using the nwg-look utility.
- Press `SUPER + H` to bring up a little cheatsheet with the most important keybinds. 


### ⌨ Keybinds
- All keybinds are located at `~/.config/hypr/configs/Keybinds.conf` and `~/.config/hypr/UserConfigs/UserKeybinds.conf`. Edit them as you wish.

### 🙋 Have questions or issues? 
- Issues and pull requests will most likely not be accepted, unless there is a significant vulnerability.

### 🔧 Installing a particular script from install-scripts.
- Change your directory to `~/Hyprland-Script/install-scripts` and execute your script of choice.
- For example, `./install-scripts/gtk-themes` will reinstall GTK Themes.

### 🛣️ Roadmap:
- [x] Install fish and oh-my-fish/fisher without necessary steps above. 
- [x] Add gruvbox integrations for themes, icons, and cursors.

### ❗ Known Issues
- Problems with NVIDIA
  -  If you are stuck in SDDM, try the following:

```  
Launch a new TTY instance
`lspci -nn` - find the id of your nvidia card 
`ls /dev/dri/by-path` - find the matching id
`ls -l /dev/dri/by-path` - to check where the symlink points to 
)
```
  - add `env = WLR_DRM_DEVICES,/dev/dri/cardX` to the ENVvariables config located in `~/.config/hypr/UserConfigs/ENVariables.conf`  ; X being where the symlink of the gpu points towards.

  - Read more about it on the [Hyprland Wiki](https://wiki.hyprland.org/FAQ/#my-external-monitor-is-blank--doesnt-render--receives-no-signal-laptop)

  - If nvidia is still not working properly, uncomment the following lines in `~/.config/hypr/UserConfigs/ENVariables.conf`
```
env = GBM_BACKEND,nvidia-drm
env = WLR_RENDERER_ALLOW_SOFTWARE,1
```
- Installing `cava-git` on a new Arch install causes it to not boot properly. After successfully booting and logging in if cava does not work, replace it with `cava-git` from the AUR. 
> [!NOTE]
> Automatically launching Hyprland after logging into TTY
- This has been disabled by default. If other desktop environments are installed on the system, it will not allow them to start. You may re-enable this by uncommenting the first few lines in `~/.zprofile`. 

### 📒 Final Notes
- Feel free to copy, re-distribute, and use this script however you want. Would appreciate if you give me some loves by crediting my work :)

### ⏩ Contributing
- These script do not contain actual configuration files. These only install packages.
- The development branch of this script is pulling the latest "stable" releases of the dotfiles.


### 👍 Thanks and Credits!
- [`Hyprland`](https://hyprland.org/) Of course to Hyprland and [vaxerski](https://github.com/vaxerski) for this awesome Dynamic Tiling Manager.
- [`JaKooLit`](https://github.com/JaKooLiT) For providing a foundation for such nice dotfiles and scripts.

## 💖 Support
- Leaving a star on my Github repositories would be nice 🌟
- Subscribe to my [YouTube channel](https://www.youtube.com/@ecys) 📹

<div align="center">

## [🥰🥰 💖💖 👍👍👍](https://ecys.xyz)
</div>
