#! /bin/bash

current_wallpaper="$(osascript -e 'tell app "finder" to get posix path of (get desktop picture as alias)')"

old_wallpaper=$(cat /tmp/pywal.txt)

if [ "$current_wallpaper" != "$old_wallpaper" ]
then

    wal -i "$current_wallpaper" -n

    echo "$current_wallpaper" > /tmp/pywal.txt

    #reload alfred
    osascript -e '
        try
                tell application "Alfred 4"
                        quit
                end tell
        end try

        delay 0.05
        try 
                tell application "Alfred 4" to open
        end try

        delay 0.05
        try 
                tell application "Alfred 4" to open
        end try

        delay 0.1
        try 
                tell application "Alfred 4" to open
        end try

        delay 0.1
        try 
                tell application "Alfred 4" to open
        end try

        delay 0.1
        try 
                tell application "Alfred 4" to open
        end try

        delay 0.1
        try 
                tell application "Alfred 4" to open
        end try

        delay 0.25
        try 
                tell application "Alfred 4" to open
        end try

        delay 0.25
        try 
                tell application "Alfred 4" to open
        end try

        delay 0.5
        try 
                tell application "Alfred 4" to open
        end try'

fi


