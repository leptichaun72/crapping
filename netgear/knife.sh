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
three(){
  echo tree

  pause
}
four(){
  echo "Started reconfigured DNSMasq"
  dnsmasq -h -n -c 0 -N -i br0 -r /tmp/resolv.conf -u r -H /media/cooler

  pause
}
five(){
  echo "Start analyzing packets..."
  tcpdump -n -i br0 -A -s 0 "src 192.168.1.2 and (port 80 or port 443)"
  ## tcpdump -n -i br0 dst port 53 2>&1
  
  pause
}

# function to display menus
show_menus() {
  echo "~~~~~~~~~~~~~~~~~~~~~"	
  echo " M A I N - M E N U"
  echo "~~~~~~~~~~~~~~~~~~~~~"
  echo "1. Setup environment"
  echo "2. Start FTP daemon"
  echo "3. IP Firewall"
  echo "4. Restart 'hosted' dnsmasq"
  echo "5. Tcpdump"
  echo "6. Exit"
}
# read input from the keyboard and take a action
# invoke the one() when the user select 1 from the menu option.
# invoke the two() when the user select 2 from the menu option.
# Exit when user the user select 3 form the menu option.
read_options(){
  local choice
  read -p "Enter choice [1 - 6] " choice
  case $choice in
    1) one ;;
    2) two ;;
    3) three ;;
    4) four ;;
    5) five ;;
    6) break;;
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
