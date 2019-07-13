#!/bin/bash
 
mate-settings-daemon &
mate-power-manager &
clipmenud &
compton &
pidgin &
rm -rf /tmp/bandwidth-upload
rm -rf /tmp/bandwidth-download
bwm --interval 500 --interface wlan0 --upload > /tmp/bandwidth-upload &
bwm --interval 500 --interface wlan0 --download > /tmp/bandwidth-download &
/home/fperson/bin/setbg &
#xscreensaver &

export LANG=hy_AM.UTF-8

sudo pkill -u openvpn_as &
sudo pkill -f python &

dte(){
    dte="\uf5ec$(date +"%A, %B %d^d^|^c#A24C57^\uf64f%H:%M")"
    echo -e "$dte"
}

mem(){
    #mem=`free | awk '/Mem/ {printf "%d MiB/%d MiB\n", $3 / 1024.0, $2 / 1024.0 }'`
    mem=`free | awk '/Mem/ {printf "%d/%d MiB\n", $3 / 1024.0, $2 / 1024.0 }'`
    echo -e "\uf85a$mem"
}

cpu(){
    read cpu a b c previdle rest < /proc/stat
    prevtotal=$((a+b+c+previdle))
    sleep 0.5
    read cpu a b c idle rest < /proc/stat
    total=$((a+b+c+idle))
    cpu=$((100*( (total-prevtotal) - (idle-previdle) ) / (total-prevtotal) ))
    echo -e "\uf821$cpu% cpu"
}

#ssid(){
#ssid=`iwconfig 2>/dev/null | grep --extended-regexp --only-matching 'ESSID:*.*"' | sed --expression 's/ESSID://' --expression 's/"//g'`
#echo -e "\ufaa8$ssid"
#}

band(){
    down=`sed -n '$p' /tmp/bandwidth-download | sed -e 's/^[ \t]*//'`
    up=`sed -n '$p' /tmp/bandwidth-upload | sed -e 's/^[ \t]*//'`
    echo -e "\u2191$up \u2193$down"
}

bat(){
    bat=`cat /sys/class/power_supply/BATT/capacity`
    if [ "$(cat /sys/class/power_supply/BATT/status)" = "Charging" ]
    then
        echo -e "\uf584$bat%"
    else
    echo -e "\uf578$bat%"
    fi
}

wifi(){
    ssid=`nmcli dev wifi list | awk '/\*/{if (NR!=1) {print $2}}'`
    strength=`nmcli dev wifi list | awk '/\*/{if (NR!=1) {print $7}}'`
    if [ -z "$ssid" ]
    then
        echo -e "\ufaa9"
    else
        echo -e "\ufaa8$ssid $strength%"
    fi
}

#colors - #B11F38 #E77A3D #EBD524 #4AA77A #685B87 #A24C57

while true; do
    #xsetroot -name "$(cpu) | $(mem) | $(ssid) | $(dte)"
    #xsetroot -name "$(cpu)|$(mem)|$(ssid)|$(dte)"
    xsetroot -name "^c#B11F38^$(bat)^d^|^c#E77A3D^$(cpu)^d^|^c#EBD524^$(mem)^d^|^c#4AA77A^$(wifi)^d^|^c#685B87^$(band)^d^|^c#A24C57^$(dte)"
    sleep 1s
done &
