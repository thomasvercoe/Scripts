#!/bin/bash


#get wallpapers
wallpapers () {
    xfconf-query -c xfce4-desktop -lv | grep /home/thomas/backgrounds
}




#get monitor
monitor="$(xrandr|awk '/\<connected/{print "monitor"$1}')"

var_wallpapers="$(wallpapers)"


while true; do

    #get current workspace
    workspace="$(xdotool get_desktop)"


    wallpaper="$(echo "$var_wallpapers" | grep "$monitor" | grep "workspace$workspace"| sed -n -e 's/^.*last-image             //p')"



    if [[ "$(basename "$wallpaper")" != "$(wpg -c)" ]]
    then

        wpg -a "$wallpaper"
        wpg -s "$wallpaper"

        wallpapers
        var_wallpapers="$(wallpapers)"

    fi



    sleep 0.1

done