#! /bin/bash

current_wallpaper="$(osascript -e 'tell app "finder" to get posix path of (get desktop picture as alias)')"

old_wallpaper=$(cat /tmp/pywal.txt)

if [ "$current_wallpaper" != "$old_wallpaper" ]
then

    wal -i "$current_wallpaper" -n


    #reload alfred
    osascript -e 'tell application "Alfred 4"
                quit
        end tell

        delay 0.05

        tell application "Alfred 4" to activate'

fi

echo "$current_wallpaper" > /tmp/pywal.txt
