#! /bin/bash

touch /tmp/pywal.txt

current_wallpaper="$(osascript -e 'tell app "finder" to get posix path of (get desktop picture as alias)')"

old_wallpaper=$(cat /tmp/pywal.txt)

if [ "$current_wallpaper" != "$old_wallpaper" ]
then

    wal -i "$current_wallpaper" -n

    echo "$current_wallpaper" > /tmp/pywal.txt

    #reload alfred
    killall "Alfred"
    open -j -a "Alfred 4"

fi