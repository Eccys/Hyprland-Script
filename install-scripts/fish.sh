#!/bin/bash
# Made by Ecys — https://ecys.xyz
# fish and oh my fish including pokemon-color-scripts#
if [[ $USE_PRESET = [Yy] ]]; then
  source ./preset.sh
fi

fish_packages=(
fish
fisher
fzf
)


## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##
# Determine the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || exit 1

source "$(dirname "$(readlink -f "$0")")/Global_functions.sh"

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d-%H%M%S)_fish.log"

## Optional Pokemon color scripts
while true; do
    if [[ -z $pokemon_choice ]]; then
       read -p "${CAT} OPTIONAL - Do you want to add Pokemon color scripts? (y/n): " pokemon_choice
    fi
    case "$pokemon_choice" in
        [Yy]*)
            fish_packages+=('pokemon-colorscripts-git')
            sed -i '/#pokemon-colorscripts --no-title -s -r/s/^#//' assets/config.fish
            break
            ;;
        [Nn]*)
            echo "${NOTE}Skipping Pokemon color scripts installation.${RESET}" 2>&1 | tee -a "$LOG"
            break
            ;;
        *)
            echo "${WARN}Please enter 'y' for yes or 'n' for no.${RESET}"
            ;;
    esac
done

# Installing fish packages
printf "${NOTE} Installing core fish packages...${RESET}\n"
for FISH_PKG in "${fish_packages[@]}"; do
  install_package "$FISH_PKG" 2>&1 | tee -a "$LOG"
  if [ $? -ne 0 ]; then
     echo -e "\e[1A\e[K${ERROR} - $FISH_PKG Package installation failed, Please check the installation logs"
  fi
done

# Install Oh My Fish and plugins, and set fish as default shell
if command -v fish >/dev/null; then
  printf "${NOTE} Installing Oh My Fish and plugins...\n"
	if [ ! -d "$HOME/.local/share/omf" ]; then
  		curl -L https://get.oh-my.fish | fish || true
	else
		echo "Directory .local/share/omf already exists. Skipping re-installation." 2>&1 | tee -a "$LOG"
	fi

	# Install Oh My Fish plugins
	fish -c "fisher install jorgebucaran/fisher" || true

	# Check if the directories exist before cloning the repositories
	if [ ! -d "$HOME/.config/fish/functions/fish_prompt.fish" ]; then
    	fish -c "fisher install jorgebucaran/fish-prompt-metro" || true
	else
    	echo "Directory fish-prompt already exists. Skipping cloning." 2>&1 | tee -a "$LOG"
	fi
	
	# Check if config.fish exists, create a backup, and copy the new configuration
	if [ -f "$HOME/.config/fish/config.fish" ]; then
    	cp -b "$HOME/.config/fish/config.fish" "$HOME/.config/fish/config.fish-backup" || true
	fi
	
	# Copying the preconfigured fish themes and profile
    cp -r 'assets/config.fish' ~/.config/fish/
    cp -r 'assets/fish_plugins' ~/.config/fish/

    printf "${NOTE} Changing default shell to fish...\n"

	while ! chsh -s $(which fish); do
    	echo "${ERROR} Authentication failed. Please enter the correct password." 2>&1 | tee -a "$LOG"
    	sleep 1
	done
	printf "${NOTE} Shell changed successfully to fish.\n" 2>&1 | tee -a "$LOG"

fi

clear

