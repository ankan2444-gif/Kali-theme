#!/data/data/com.termux/files/usr/bin/bash

clear
echo -e "\e[1;36m[*] Installing Kali-Termux Theme & Commands...\e[0m"

# 1. Required Packages Install
pkg update -y && pkg upgrade -y
pkg install zsh git neofetch curl -y

# 2. Default Termux Welcome Text Band Karo
touch ~/.hushlogin

# 3. High-Contrast Kali Color Palette Set Karo
mkdir -p ~/.termux
cat << 'COLORS' > ~/.termux/colors.properties
background=#05070a
foreground=#ffffff
cursor=#00ff66
color0=#000000
color1=#ff3333
color2=#00e676
color3=#ffea00
color4=#2979ff
color5=#d500f9
color6=#00e5ff
color7=#e0e0e0
color8=#546e7a
color9=#ff5252
color10=#00ff66
color11=#ffff00
color12=#448aff
color13=#e040fb
color14=#18ffff
color15=#ffffff
COLORS
termux-reload-settings 2>/dev/null

# 4. Skull aur Kali Banner Save Karo (Default: kali & localhost)
cat << 'SKULL' > ~/.banner_skull
\e[1;36m
       .ed"""" """$$$$be.
     -"           ^""**$$$e.
   ."                   '$$$c
  /                      "4$$b
 d  3                      $$$$
 $  *                   .$$$$$$
.$  ^c           $$$$$e$$$$$$$$.
d$L  4.         4$$$$$$$$$$$$$$b
$$$$b ^ceeeee.  4$$ECL.F*$$$$$$$
$$$$P d$$$$F $ $$$$$$$$$- $$$$$$
3$$$F "$$$$b   $"$$$$$$$  $$$$*"
 $$P"  "$$b   .$ $$$$$...e$$
  *c    ..    $$ 3$$$$$$$$$$eF
    %ce""    $$$  $$$$$$$$$$*
     *$e.    *** d$$$$$"L$$
      $$$      4J$$$$$% $$$
     $"'$=e....$*$$**$cz$$"
     $  *=%4.$ L L$ P3$$$F
     $   "%*ebJLzb$e$$$$$b
      %..      4$$$$$$$$$$
       $$$e   z$$$$$$$$$$%
        "*$c  "$$$$$$$P"
          """*$$$$$$$"
\e[1;32m  ┌────────────────────────────────────┐
  │ \e[1;36mOS\e[1;37m     : Kali Rolling (Termux)     \e[1;32m│
  │ \e[1;36mSHELL\e[1;37m  : Zsh + KaliPrompt          \e[1;32m│
  │ \e[1;36mSKULL MODE\e[1;37m: ON \e[1;32m│
  └────────────────────────────────────┘\e[0m
SKULL

neofetch --ascii_distro Kali > ~/.banner_kali
echo "kali" > ~/.active_banner
echo "localhost" > ~/.kali_host

# 5. Zsh Config with 'show' & 'kaliset' Commands
cat << 'EOF' > ~/.zshrc
# Dynamic Prompt Function (Default: localhost)
set_kali_prompt() {
  local HOST_NAME=$(cat ~/.kali_host 2>/dev/null)
  [[ -z "$HOST_NAME" ]] && HOST_NAME="localhost"
  PROMPT=$'%F{%(#.blue.green)}┌──(%B%F{%(#.red.blue)}kali㉿'"${HOST_NAME}"$'%b%F{%(#.blue.green)})-[%B%F{reset}%(6~.%-1~/…/%4~.%5~)%b%F{%(#.blue.green)}]\n└─%B%(#.%F{red}#.%F{blue}$)%b%F{reset} '
}
set_kali_prompt

HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt autocd

# Command 1: Change Hostname (kaliset <name>)
kaliset() {
  if [[ -z "$1" ]]; then
    echo -e "\e[1;33mUsage:\e[0m kaliset <your-name>  |  kaliset reset"
  elif [[ "$1" == "reset" ]]; then
    echo "localhost" > ~/.kali_host
    set_kali_prompt
    echo -e "\e[1;32m[✔] Host reset to localhost\e[0m"
  else
    echo "$1" > ~/.kali_host
    set_kali_prompt
    echo -e "\e[1;32m[✔] Prompt updated to kali㉿$1\e[0m"
  fi
}

# Command 2: Switch Banner (show skull / show kali)
show() {
  if [[ "$1" == "skull" ]]; then
    echo "skull" > ~/.active_banner
    clear
    printf '%b\n' "$(cat ~/.banner_skull)"
  elif [[ "$1" == "kali" ]]; then
    echo "kali" > ~/.active_banner
    clear
    cat ~/.banner_kali
  else
    echo -e "\e[1;33mUsage:\e[0m show skull  |  show kali"
  fi
}

# Load Selected Banner on Startup
clear
if [[ "$(cat ~/.active_banner 2>/dev/null)" == "skull" ]]; then
  printf '%b\n' "$(cat ~/.banner_skull)"
else
  cat ~/.banner_kali
fi
EOF

# 6. Set Zsh as Default Shell
chsh -s zsh

echo -e "\n\e[1;32m[✔] Installation Complete!\e[0m"
echo -e "\e[1;36m[i] Banner Switch :\e[0m show skull  |  show kali"
echo -e "\e[1;36m[i] Custom Name   :\e[0m kaliset <name>  |  kaliset reset\n"
sleep 1
exec zsh
