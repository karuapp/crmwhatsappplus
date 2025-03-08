#!/bin/bash
#
# Print banner art.

#######################################
# Print a board. 
# Globals:
#   BG_BROWN
#   NC
#   WHITE
#   CYAN_LIGHT
#   RED
#   GREEN
#   YELLOW
# Arguments:
#   None
#######################################
print_banner() {

  clear

  printf "\n\n"

  printf "${GREEN}";
  printf "  _____  _    _ _____  _  ____     __   _____ _      ____  _    _ _____  \n";
  printf " |  __ \| |  | |  __ \| |/ /\ \   / /  / ____| |    / __ \| |  | |  __ \ \n";
  printf " | |  | | |  | | |__) | ' /  \ \_/ /  | |    | |   | |  | | |  | | |  | |\n";
  printf " | |  | | |  | |  _  /|  <    \   /   | |    | |   | |  | | |  | | |  | |\n";
  printf " | |__| | |__| | | \ \| . \    | |    | |____| |___| |__| | |__| | |__| |\n";
  printf " |_____/ \____/|_|  \_\_|\_\   |_|     \_____|______\____/ \____/|_____/ \n";
  printf "\n";
  printf "\n";
  
  printf "\n";
  printf " © Marca Blanca SAAS - marcablancasaas.com\n";
  printf "${NC}";

  printf "\n"
}
