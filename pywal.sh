#! /bin/bash

current_wallpaper="$(osascript -e 'tell app "finder" to get posix path of (get desktop picture as alias)')"

#SCAPED_REPLACE=$(printf '%s\n' "\ " | sed -e 's/[\/&]/\\&/g')

#mcw() {
    #echo $current_wallpaper | sed "s/ /$ESCAPED_REPLACE/g"
#
#mcwe=$(mcw)

wal -i "$current_wallpaper" -n


#reload alfred

osascript -e 'tell application "Alfred 4"
        quit
end tell

delay 0.2

tell application "Alfred 4" to activate'
