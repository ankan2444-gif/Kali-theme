#!/data/data/com.termux/files/usr/bin/bash

clear
echo -e "\e[1;36m[*] Installing Kali-Theme...\e[0m"

# 1. Install required packages
pkg update -y && pkg upgrade -y
pkg install zsh git neofetch curl -y

# 2. Disable default Termux welcome screen
touch ~/.hushlogin

# 3. Apply High-Contrast Kali Color Palette
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

# 4. Write clean self-contained ~/.zshrc (No extra banner files in ~)
cat << 'EOF' > ~/.zshrc
# --- Dynamic Kali Prompt ---
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

# --- Custom Name Command (kaliset <name> | kaliset reset) ---
kaliset() {
  if [[ -z "$1" ]]; then
    echo -e "\e[1;33mUsage:\e[0m kaliset <your-name>  |  kaliset reset"
  elif [[ "$1" == "reset" ]]; then
    rm -f ~/.kali_host
    set_kali_prompt
    echo -e "\e[1;32m[✔] Host reset to localhost\e[0m"
  else
    echo "$1" > ~/.kali_host
    set_kali_prompt
    echo -e "\e[1;32m[✔] Prompt updated to kali㉿$1\e[0m"
  fi
}

# --- Banner Renderer ---
render_banner() {
  local B="$1"
  clear
  case "$B" in
    kali)
      neofetch --ascii_distro Kali
      ;;
    root)
      printf '%b\n' '\e[1;31m
  ____   ___   ___ _____ 
 |  _ \ / _ \ / _ \_   _|
 | |_) | | | | | | || |  
 |  _ <| |_| | |_| || |  
 |_| \_\\___/ \___/ |_|  
\e[1;32m  [ ACCESS: GRANTED # ]\e[0m'
      ;;
    fsociety)
      printf '%b\n' '\e[1;37m
       .--------.
     .\x27          \x27.
    /   O      O   \
   :           `    :
   |   .--------.   |
   :   \________/   :
    \              /
     \x27.__________.\x27
\e[1;31m     [ FSOCIETY.DAT ]\e[0m'
      ;;
    dev)
      printf '%b\n' '\e[1;36m
      < / >  DEV MODE
\e[1;32m   ┌────────────────────┐
   │ \e[1;35mwhile\e[1;37m(alive) {     \e[1;32m│
   │   \e[1;36meat\e[1;37m();           \e[1;32m│
   │   \e[1;36msleep\e[1;37m();         \e[1;32m│
   │   \e[1;33mcode\e[1;37m();          \e[1;32m│
   │ }                  \e[1;32m│
   └────────────────────┘\e[0m'
      ;;
    hydra)
      printf '%b\n' '\e[1;32m
      _   _ __   ______  ____      _    
     | | | |\ \ / /  _ \|  _ \    / \   
     | |_| | \ V /| | | | |_) |  / _ \  
     |  _  |  | | | |_| |  _ <  / ___ \ 
     |_| |_|  |_| |____/|_| \_\/_/   \_\
\e[1;36m        [ EXPLOIT FRAMEWORK v2.0 ]\e[0m'
      ;;
    skull|*)
      printf '%b\n' '\e[1;36m
       .ed"""" """$$$$be.
     -"           ^""**$$$e.
   ."                   \x27$$$c
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
     $"\x27$=e....$*$$**$cz$$"
     $  *=%4.$ L L$ P3$$$F
     $   "%*ebJLzb$e$$$$$b
      %..      4$$$$$$$$$$
       $$$e   z$$$$$$$$$$%
        "*$c  "$$$$$$$P"
          """*$$$$$$$"
\e[1;32m  ┌────────────────────────────────────┐
  │ \e[1;36mOS\e[1;37m     : Kali Rolling (Termux)     \e[1;32m│
  │ \e[1;36mSHELL\e[1;37m  : Zsh + KaliPrompt          \e[1;32m│
  │ \e[1;36mSWITCH\e[1;37m : show list | kaliset <name>\e[1;32m│
  └────────────────────────────────────┘\e[0m'
      ;;
  esac
}

# --- Banner Switcher Command (show <name> | show list) ---
show() {
  case "$1" in
    skull|kali|root|fsociety|dev|hydra)
      echo "$1" > ~/.active_banner
      render_banner "$1"
      ;;
    list)
      echo -e "\e[1;36mAvailable Banners:\e[0m"
      echo -e "  \e[1;32m• skull\e[0m     (Default Cyber-Skull)"
      echo -e "  \e[1;32m• kali\e[0m      (Kali Dragon + Neofetch)"
      echo -e "  \e[1;32m• root\e[0m      (ROOT Access Granted)"
      echo -e "  \e[1;32m• fsociety\e[0m  (Mr. Robot Hacker Mask)"
      echo -e "  \e[1;32m• dev\e[0m       (Developer Code Mode)"
      echo -e "  \e[1;32m• hydra\e[0m     (Hydra Exploit Framework)"
      echo -e "\e[1;33mUsage:\e[0m show <name>"
      ;;
    *)
      echo -e "\e[1;33mUsage:\e[0m show <skull|kali|root|fsociety|dev|hydra>  |  show list"
      ;;
  esac
}

# Load active banner on startup (Default: skull)
ACTIVE_B=$(cat ~/.active_banner 2>/dev/null)
[[ -z "$ACTIVE_B" ]] && ACTIVE_B="skull"
render_banner "$ACTIVE_B"
EOF

# 5. Set Zsh as default shell
chsh -s zsh

echo -e "\n\e[1;32m[✔] Kali-Theme Installed! Default Banner: SKULL\e[0m"
echo -e "\e[1;36m[i] Switch Banners:\e[0m show list"
echo -e "\e[1;36m[i] Custom Prompt :\e[0m kaliset <name>\n"
sleep 1
exec zsh
