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
  read -p "Press [Enter] key to continue..." fackEnterKeya
}
one(){
  echo "Setting the environment..."
  export PATH=$PATH:/media
  alias bb="busybox-armv5l"
  alias ipt="iptables -L --line-numbers"

  pause
}
two(){
  echo "Started file server..."
  /media/busybox-armv5l tcpsvd -vE 0.0.0.0 21 /media/busybox-armv5l ftpd -w /media
  
  pause
}
mac(){
#    echo $1
    entry=$(arp -a | grep $1)
#    echo $entry
    len=${#entry}
    if [ $len -eq 51 ]; then
      ip=$(echo $entry | cut -c4-14)
      echo $ip
    else
      ip=$(echo $entry | cut -c4-15)
      echo $ip
    fi
}
three(){
  multi=$(arp -a)
  for x in "$multi"
  do
    echo "$x"
    line="$x"
    len=${#line}
    echo $len
    #foo=$(mac $line)
    #echo $foo
  done

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
six(){
#   mac 8c:86:1e:4c:d0:84
#   mac f0:ee:10:d2:1e:08
#   mac 58:63:56:7f:bf:03
  iptables -F # resets tables
  while :; do
    echo "#--SLOWING--#"
    uno="$(mac 14:d0:0d:88:8a:9f)" #BG
    iptables -A FORWARD -s "${uno}" -j DROP
#    dos="$(mac 70:bc:10:5f:2a:15)" #AlanPC
#    iptables -A FORWARD -s $dos -j DROP
#    tres="$(mac e8:e8:b7:67:b3:55)" #GS10
#    iptables -A FORWARD -s $tres -j DROP
    sleep 25
    echo "#--NON-SLOWING--#"
    iptables -F
    sleep 3
  done

#  foo=1
#  while [ $foo -lt 5 ]; do
#    echo $foo
#    foo=$(( $foo + 1 ))
#  done

  pause
}
setup() {
  curl -Ok https://www.busybox.net/downloads/binaries/1.21.1/busybox-armv5l
  chmod 755 busybox-armv5l
  curl -Ok -H 'Cache-Control: no-cache' https://raw.githubusercontent.com/leptichaun72/crapping/master/netgear/knife.sh

  one
}

# function to display menus
show_menus() {
  echo "~~~~~~~~~~~~~~~~~~~~~"	
  echo " M A I N - M E N U"
  echo "~~~~~~~~~~~~~~~~~~~~~"
  echo "1. Setup environment"
  echo "2. Start FTP daemon"
  echo "3. NIMBY IP Firewall"
  echo "4. Restart 'hosted' dnsmasq"
  echo "5. Tcpdump"
  echo "6. Loop IP Firewall"
  echo "7. Exit"
}
# read input from the keyboard and take a action
# invoke the one() when the user select 1 from the menu option.
# invoke the two() when the user select 2 from the menu option.
# Exit when user the user select 3 form the menu option.
read_options(){
  local choice
  read -p "Enter choice [1 - 7] or s " choice
  case $choice in
    1) one ;;
    2) two ;;
    3) three ;;
    4) four ;;
    5) five ;;
    6) six ;;
    7) break;;
    s) setup;;
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
