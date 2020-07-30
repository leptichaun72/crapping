#!/bin/bash
## ----------------------------------
# Step #1: Define variables
# ----------------------------------
#EDITOR=vi
RED='\033[0;41;30m'
STD='\033[0;0;39m'
 
# ----------------------------------
# Step #2: User defined function
# ----------------------------------
pause(){
  read -p "Press [Enter] key to continue..." fackEnterKey
}
one(){
  echo "Setting the environment..."
  export PATH=$PATH:/media
  alias bb="busybox-armv5l"

  pause
}
two(){
  echo "Started file server..."
  /media/busybox-armv5l tcpsvd -vE 0.0.0.0 21 /media/busybox-armv5l ftpd -w /media
  
  pause
}

# function to display menus
show_menus() {
  echo "~~~~~~~~~~~~~~~~~~~~~"	
  echo " M A I N - M E N U"
  echo "~~~~~~~~~~~~~~~~~~~~~"
  echo "1. Setup environment"
  echo "2. Start FTP daemon"
  echo "3. Exit"
}
# read input from the keyboard and take a action
# invoke the one() when the user select 1 from the menu option.
# invoke the two() when the user select 2 from the menu option.
# Exit when user the user select 3 form the menu option.
read_options(){
  local choice
  read -p "Enter choice [ 1 - 3] " choice
  case $choice in
    1) one ;;
    2) two ;;
    3) break;;
    *) echo -e "${RED}Error...${STD}" && sleep 2
  esac
}
 
# ----------------------------------------------
# Step #3: Trap CTRL+C, CTRL+Z and quit singles
# ----------------------------------------------
#trap '' SIGINT SIGQUIT SIGTSTP
 
# -----------------------------------
# Step #4: Main logic - infinite loop
# ------------------------------------
while :
do
  show_menus
  read_options
done
