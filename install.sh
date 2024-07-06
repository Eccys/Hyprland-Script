#!/bin/bash

# Made by Ecys — https://ecys.xyz

# Check if running as root. If root, script will exit
if [[ $EUID -eq 0 ]]; then
    echo "Error: running as root.\nExiting..."
    exit 1
fi

clear

# Welcome message
echo "$(tput setaf 6)Welcome to the Hyprland on Arch install script!$(tput sgr0)"
echo
echo "$(tput setaf 166)It is recommended to reboot and do a full system upgrade before proceeding.$(tput sgr0)"
echo
echo "$(tput setaf 3)NOTE: Please enable 3D acceleration if running on a virtual machine. $(tput sgr0)"
echo

read -p "$(tput setaf 6)Would you like to proceed? (y/n): $(tput sgr0)" proceed

printf "\n%.0s" {1..2}

if [[ "$proceed" != "y" && "$proceed" != "Y" ]]; then
    echo "Installation aborted."
    printf "\n%.0s" {1..2}
    exit 1
fi

printf "\n%.0s" {1..2}

read -p "$(tput setaf 6)Would you like to use a predefined preset settings? (y/n): $(tput sgr0)" use_preset

# Use of Preset Settings
if [[ $use_preset = [Yy] ]]; then
  source ./preset.sh
fi

# Set some colors for output messages
OK="$(tput setaf 2)[ OK ] $(tput sgr0)"
ERROR="$(tput setaf 1)[ ERROR ] $(tput sgr0)"
NOTE="$(tput setaf 3)[ NOTE ] $(tput sgr0)"
WARN="$(tput setaf 166)[ WARN ] $(tput sgr0)"
CAT="$(tput setaf 6)[ ACTION ] $(tput sgr0)"
ORANGE=$(tput setaf 166)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)


# Function to colorize prompts
colorize_prompt() {
    local color="$1"
    local message="$2"
    echo -n "${color}${message}$(tput sgr0)"
}

# Set the name of the log file to include the current date and time
LOG="install-$(date +%d-%H%M%S).log"

# Initialize variables to store user responses
# aur_helper=""
# bluetooth=""
# dots=""
# gtk_themes=""
# nvidia=""
# rog=""
# sddm=""
# thunar=""
# xdph=""
# fish=""

# Create Directory for Install Logs
if [ ! -d Install-Logs ]; then
    mkdir Install-Logs
fi

# Define the directory where your scripts are located
script_directory=install-scripts

# Function to ask a yes/no question and set the response in a variable
ask_yes_no() {
  if [[ ! -z "${!2}" ]]; then
    echo "$(colorize_prompt "$CAT"  "$1 (Preset): ${!2}")" 
    if [[ "${!2}" = [Yy] ]]; then
      return 0
    else
      return 1
    fi
  else
    eval "$2=''" 
  fi
    while true; do
        read -p "$(colorize_prompt "$CAT"  "$1 (y/n): ")" choice
        case "$choice" in
            [Yy]* ) eval "$2='Y'"; return 0;;
            [Nn]* ) eval "$2='N'"; return 1;;
            * ) echo "Please enter "Y" for yes, or "N" for no.";;
        esac
    done
}

# Function to ask a custom question with specific options and set the response in a variable
ask_custom_option() {
    local prompt="$1"
    local valid_options="$2"
    local response_var="$3"

    if [[ ! -z "${!3}" ]]; then
      return 0
    else
     eval "$3=''" 
    fi

    while true; do
        read -p "$(colorize_prompt "$CAT"  "$prompt ($valid_options): ")" choice
        if [[ " $valid_options " == *" $choice "* ]]; then
            eval "$response_var='$choice'"
            return 0
        else
            echo "Please choose one of the provided options: $valid_options"
        fi
    done
}
# Function to execute a script if it exists and make it executable
execute_script() {
    local script="$1"
    local script_path="$script_directory/$script"
    if [ -f "$script_path" ]; then
        chmod +x "$script_path"
        if [ -x "$script_path" ]; then
            env USE_PRESET=$use_preset  "$script_path"
        else
            echo "Failed to make script '$script' executable."
        fi
    else
        echo "Script '$script' not found in '$script_directory'."
    fi
}

# Collect user responses to all questions
printf "\n"
ask_custom_option "- Select your AUR helper" "Available options: paru, yay" aur_helper
printf "\n"
ask_yes_no "- Install nvidia drivers? [y/n]" nvidia
printf "\n"
ask_yes_no "- Install GTK themes? [y/n]" gtk_themes
printf "\n"
ask_yes_no "- Install bluetooth? [y/n]" bluetooth
printf "\n"
ask_yes_no "- Install Thunar file manager? [y/n]" thunar
printf "\n"
ask_yes_no "- Install SDDM login manager? [y/n]" sddm
printf "\n"
ask_yes_no "- Install screenshare capability? [y/n]" xdph
printf "\n"
ask_yes_no "- Install fish? [y/n]" fish
printf "\n"
ask_yes_no "- Install ASUS ROG software? [y/n]" rog
printf "\n"
ask_yes_no "- Install pre-configured Hyprland configuration files?" dots
printf "\n"

# Ensuring all in the scripts folder are made executable
chmod +x install-scripts/*
sleep 0.5
# Ensuring base-devel is installed
execute_script "00-base.sh"
sleep 0.5
execute_script "pacman.sh"
sleep 0.5
# Execute AUR helper script based on user choice
if [ "$aur_helper" == "paru" ]; then
    execute_script "paru.sh"
elif [ "$aur_helper" == "yay" ]; then
    execute_script "yay.sh"
fi

# Install hyprland packages
execute_script "00-hypr-pkgs.sh"

# Install pipewire and pipewire-audio
execute_script "pipewire.sh"

# Install necessary fonts
execute_script "fonts.sh"

# Install hyprland
execute_script "hyprland.sh"

if [ "$nvidia" == "Y" ]; then
    execute_script "nvidia.sh"
fi

if [ "$gtk_themes" == "Y" ]; then
    execute_script "gtk_themes.sh"
fi

if [ "$bluetooth" == "Y" ]; then
    execute_script "bluetooth.sh"
fi

if [ "$thunar" == "Y" ]; then
    execute_script "thunar.sh"
fi

if [ "$sddm" == "Y" ]; then
    execute_script "sddm.sh"
fi

if [ "$xdph" == "Y" ]; then
    execute_script "xdph.sh"
fi

if [ "$fish" == "Y" ]; then
    execute_script "fish.sh"
fi

execute_script "InputGroup.sh"

if [ "$rog" == "Y" ]; then
    execute_script "rog.sh"
fi

if [ "$dots" == "Y" ]; then
    execute_script "dotfiles.sh"

fi


printf "\n${OK} Installation Completed.\n"
printf "\n"
sleep 2
printf "\n${NOTE} You may start Hyprland by executing \"Hyprland\".\n"
printf "\n"
printf "\n${NOTE} It is highly recommended to reboot your system.\n\n"

read -rp "${CAT} Would you like to reboot now? (y/n): " HYP

if [[ "$HYP" =~ ^[Yy]$ ]]; then
    if [[ "$nvidia" == "Y" ]]; then
        echo "${NOTE} NVIDIA GPU detected. Rebooting the system..."
        systemctl reboot
    else
        systemctl reboot
    fi    
fi

