#!/data/data/com.termux/files/usr/bin/bash

clear
echo -e "\e[1;36m[*] Installing Kali-Theme (Centered & High-Detail)...\e[0m"

# 1. Install required packages
pkg update -y && pkg upgrade -y
pkg install zsh git neofetch curl ncurses-utils -y

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

# 4. Write clean self-contained ~/.zshrc
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

# --- Auto-Center Helper Function ---
center_block() {
  local cols=$(tput cols 2>/dev/null)
  [[ -z "$cols" || "$cols" -lt 20 ]] && cols=44
  local max_len=0
  local line clean_line len

  while IFS= read -r line; do
    clean_line=$(printf '%b' "$line" | sed 's/\x1b\[[0-9;]*m//g')
    len=${#clean_line}
    (( len > max_len )) && max_len=$len
  done <<< "$1"

  local pad=$(( (cols - max_len) / 2 ))
  (( pad < 0 )) && pad=0
  local spaces=$(printf '%*s' "$pad" "")

  while IFS= read -r line; do
    printf '%s%b\n' "$spaces" "$line"
  done <<< "$1"
}

# --- Banner Renderer ---
render_banner() {
  local B="$1"
  clear
  echo ""
  case "$B" in
    skull)
      local HOST_NAME=$(cat ~/.kali_host 2>/dev/null)
      [[ -z "$HOST_NAME" ]] && HOST_NAME="localhost"
      local KERNEL=$(uname -r | cut -d'-' -f1)
      local UPTIME=$(uptime -p 2>/dev/null | sed 's/up //')
      [[ -z "$UPTIME" ]] && UPTIME="Active"
      local PKGS=$(dpkg -l 2>/dev/null | grep -c '^ii')

      printf '%b\n' "\e[1;36m     .ed\"\"\"\" \"\"\"\$\$\$\$be.         \e[1;32mkali\e[1;37m@\e[1;34m${HOST_NAME}
\e[1;36m   -\"           ^\"\"**\$\$\$e.      \e[1;37m------------------
\e[1;36m .\"                   '\$\$\$c     \e[1;36mOS\e[1;37m: Kali Rolling
\e[1;36m/                      \"4\$\$b    \e[1;36mHost\e[1;37m: Termux Mobile
\e[1;36md  3                      \$\$\$\$    \e[1;36mKernel\e[1;37m: ${KERNEL}
\e[1;36m\$  *                   .\$\$\$\$\$\$   \e[1;36mUptime\e[1;37m: ${UPTIME}
\e[1;36m.\$  ^c           \$\$\$\$\$e\$\$\$\$\$\$\$\$.  \e[1;36mPackages\e[1;37m: ${PKGS} (dpkg)
\e[1;36md\$L  4.         4\$\$\$\$\$\$\$\$\$\$\$\$\$\$b \e[1;36mShell\e[1;37m: zsh ${ZSH_VERSION}
\e[1;36m\$\$\$\$b ^ceeeee.  4\$\$ECL.F*\$\$\$\$\$\$\$ \e[1;36mTheme\e[1;37m: Kali-Skull
\e[1;36m\$\$\$\$P d\$\$\$\$F \$ \$\$\$\$\$\$\$\$\$- \$\$\$\$\$\$ \e[1;36mSwitch\e[1;37m: show list
\e[1;36m3\$\$\$F \"\$\$\$\$b   \$\"\$\$\$\$\$\$\$  \$\$\$\$*\"
\e[1;36m \$\$P\"  \"\$\$b   .\$ \$\$\$\$\$...e\$\$     \e[40m   \e[41m   \e[42m   \e[43m   \e[44m   \e[45m   \e[46m   \e[47m   \e[0m
\e[1;36m  *c    ..    \$\$ 3\$\$\$\$\$\$\$\$\$\$eF   \e[100m   \e[101m   \e[102m   \e[103m   \e[104m   \e[105m   \e[106m   \e[107m   \e[0m
\e[1;36m    %ce\"\"    \$\$\$  \$\$\$\$\$\$\$\$\$\$*
\e[1;36m     *\$e.    *** d\$\$\$\$\$\"L\$\$
\e[1;36m      \$\$\$      4J\$\$\$\$\$% \$\$\$
\e[1;36m     \$'\"=e....\$*\$\$**\$\$cz\$\$\"
\e[1;36m     \$  *=%4.\$ L L\$ P3\$\$\$F
\e[1;36m     \$   \"%*ebJLzb\$e\$\$\$\$\$b
\e[1;36m      %..      4\$\$\$\$\$\$\$\$\$\$
\e[1;36m       \$\$\$e   z\$\$\$\$\$\$\$\$\$\$%
\e[1;36m        \"*\$c  \"\$\$\$\$\$\$\$P\"
\e[1;36m          \"\"\"*\$\$\$\$\$\$\$\"\e[0m"
      ;;
    eyes)
      local ART='\e[1;31m      ..::::::::..              ..::::::::..
   .::'\''          '\''::.        .::'\''          '\''::.
 .::    .::::::.    ::.    .::    .::::::.    ::.
::    .::'\''    '\''::.    ::  ::    .::'\''    '\''::.    ::
::   ::   \e[1;37m(@@)\e[1;31m   ::   ::::   ::   \e[1;37m(@@)\e[1;31m   ::   ::
::    '\''::.    .::'\''    ::  ::    '\''::.    .::'\''    ::
 '\''::    '\''::::::'\''    ::'\''    '\''::    '\''::::::'\''    ::'\''
   '\''::..        ..::'\''        '\''::..        ..::'\''
      '\'''\''::::::::'\'''\''              '\'''\''::::::::'\'''\''
\e[1;36m  ┌──────────────────────────────────────────┐
  │ \e[1;31mWATCHER\e[1;37m : ALL-SEEING CYBER EYES          \e[1;36m│
  │ \e[1;31mSTATUS\e[1;37m  : TARGET LOCKED // TRACKING      \e[1;36m│
  └──────────────────────────────────────────┘\e[0m'
      center_block "$ART"
      ;;
    root)
      local ART='\e[1;31m██████╗  ██████╗  ██████╗ ████████╗
██╔══██╗██╔═══██╗██╔═══██╗╚══██╔══╝
██████╔╝██║   ██║██║   ██║   ██║   
██╔══██╗██║   ██║██║   ██║   ██║   
██║  ██║╚██████╔╝╚██████╔╝   ██║   
╚═╝  ╚═╝ ╚═════╝  ╚═════╝    ╚═╝   
\e[1;32m┌─────────────────────────────────┐
│     [ ACCESS: GRANTED # ]       │
└─────────────────────────────────┘\e[0m'
      center_block "$ART"
      ;;
    fsociety)
      local ART='\e[1;37m         _.-""""""""""-._
       .'\''  _..------.._  '\''.
      /  .'\''  _      _  '\''.  \
     |  /   / \    / \   \  |
     | |   ( O )  ( O )   | |
     | |    \_/    \_/    | |
     |  \       /\       /  |
      \  '\''.   .'\''  '\''.   .'\''  /
       '\''.  '\''-'\''------'\''-'\''  .'\''
         '\''-..________..-'\''
\e[1;31m┌─────────────────────────────────┐
│        [ FSOCIETY.DAT ]         │
└─────────────────────────────────┘\e[0m'
      center_block "$ART"
      ;;
    dev)
      local ART='\e[1;36m       < / >  DEV MODE
\e[1;32m┌────────────────────────────────┐
│ \e[1;35mwhile\e[1;37m (alive) {                \e[1;32m│
│   \e[1;36meat\e[1;37m();                       \e[1;32m│
│   \e[1;36msleep\e[1;37m();                     \e[1;32m│
│   \e[1;33mcode\e[1;37m();                      \e[1;32m│
│ }                              \e[1;32m│
└────────────────────────────────┘\e[0m'
      center_block "$ART"
      ;;
    hydra)
      local ART='\e[1;32m██╗  ██╗██╗   ██╗██████╗ ██████╗  █████╗ 
██║  ██║╚██╗ ██╔╝██╔══██╗██╔══██╗██╔══██╗
███████║ ╚████╔╝ ██║  ██║██████╔╝███████║
██╔══██║  ╚██╔╝  ██║  ██║██╔══██╗██╔══██║
██║  ██║   ██║   ██████╔╝██║  ██║██║  ██║
╚═╝  ╚═╝   ╚═╝   ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝
\e[1;36m┌────────────────────────────────────────┐
│       [ EXPLOIT FRAMEWORK v2.0 ]       │
└────────────────────────────────────────┘\e[0m'
      center_block "$ART"
      ;;
    kali|*)
      neofetch --ascii_distro Kali
      ;;
  esac
  echo ""
}

# --- Banner Switcher Command (show <name> | show list) ---
show() {
  case "$1" in
    kali|skull|eyes|root|fsociety|dev|hydra)
      echo "$1" > ~/.active_banner
      render_banner "$1"
      ;;
    list)
      echo -e "\e[1;36mAvailable Banners:\e[0m"
      echo -e "  \e[1;32m• kali\e[0m      (Default Kali Dragon + Neofetch)"
      echo -e "  \e[1;32m• skull\e[0m     (High-Detail Skull + System Info)"
      echo -e "  \e[1;32m• eyes\e[0m      (Dot-Coded Cyber Eyes)"
      echo -e "  \e[1;32m• root\e[0m      (Big Block ROOT Access)"
      echo -e "  \e[1;32m• fsociety\e[0m  (Mr. Robot Hacker Mask)"
      echo -e "  \e[1;32m• dev\e[0m       (Developer Code Mode)"
      echo -e "  \e[1;32m• hydra\e[0m     (Big Block HYDRA Exploit)"
      echo -e "\e[1;33mUsage:\e[0m show <name>"
      ;;
    *)
      echo -e "\e[1;33mUsage:\e[0m show <kali|skull|eyes|root|fsociety|dev|hydra>  |  show list"
      ;;
  esac
}

# Load active banner on startup (Default: kali)
ACTIVE_B=$(cat ~/.active_banner 2>/dev/null)
[[ -z "$ACTIVE_B" ]] && ACTIVE_B="kali"
render_banner "$ACTIVE_B"
EOF

# 5. Set default active banner to kali & Zsh as default shell
echo "kali" > ~/.active_banner
chsh -s zsh

echo -e "\n\e[1;32m[✔] Kali-Theme Installed! Default Banner: KALI\e[0m"
echo -e "\e[1;36m[i] Switch Banners:\e[0m show list"
echo -e "\e[1;36m[i] Custom Prompt :\e[0m kaliset <name>\n"
sleep 1
exec zsh
