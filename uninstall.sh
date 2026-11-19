#!/data/data/com.termux/files/usr/bin/bash

echo -e "\e[1;33m[*] Removing Kali-theme and restoring default Termux...\e[0m"

rm -rf ~/.zshrc ~/.banner_skull ~/.banner_kali ~/.active_banner ~/.kali_host ~/.hushlogin ~/.termux/colors.properties
chsh -s bash
termux-reload-settings 2>/dev/null

echo -e "\e[1;32m[✔] Default Termux restored!\e[0m"
sleep 1
exec bash
