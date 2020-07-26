#!/usr/bin/bash
 
cd

/home/fperson/bin/greenclip daemon &
dino &
telegram-desktop &
slack &
tilda &
xbindkeys &
xfce4-power-manager &
redshift &

rm -rf /tmp/bandwidth-upload
rm -rf /tmp/bandwidth-download
bwm --interval 500 --interface wlp2s0 --upload > /tmp/bandwidth-upload &
bwm --interval 500 --interface wlp2s0 --download > /tmp/bandwidth-download &

setxkbmap "us, am(phonetic-alt)" -option "grp:win_space_toggle,grp_led:scroll"
export LANG=hy_AM.UTF-8

dte(){
    dte="\uf5ec$(date +"%A, %B %d^d^|^c#A24C57^\uf64f%H:%M")"
    echo -e "$dte"
}

mem(){
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

band(){
    down=`sed -n '$p' /tmp/bandwidth-download | sed -e 's/^[ \t]*//'`
    up=`sed -n '$p' /tmp/bandwidth-upload | sed -e 's/^[ \t]*//'`
    echo -e "\u2191$up \u2193$down"
}

bat(){
    bat=`cat /sys/class/power_supply/BAT0/capacity`
    if [ "$(cat /sys/class/power_supply/BAT0/status)" = "Charging" ]
    then
        echo -e "\uf584$bat%"
    else
    echo -e "\uf578$bat%"
    fi
}

wifi(){
	ssid=`iwgetid -r`
	strength=`nmcli -t -f SSID,SIGNAL device wifi | grep $ssid: | cut -f2- -d:`

	if [ -z "$ssid" ]
    then
        echo -e "\ufaa9"
    else
        echo -e "\ufaa8$ssid $strength%"
    fi
}

#colors: #B11F38 #E77A3D #EBD524 #4AA77A #685B87 #A24C57
while true
do
    xsetroot -name "^c#B11F38^$(bat)^d^|^c#E77A3D^$(cpu)^d^|^c#EBD524^$(mem)^d^|^c#4AA77A^$(wifi)^d^|^c#685B87^$(band)^d^|^c#A24C57^$(dte)"
    sleep 1s
done
