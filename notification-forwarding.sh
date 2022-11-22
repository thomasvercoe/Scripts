#!/bin/bash

string=$1
if [[ $string == *"hexchat"* ]]
  then
    
    {
    echo From: thvercoe@gmail.com
    echo To: thvercoe@icloud.com
    echo Subject: Hexchat
    echo 
    echo $string
    } | sendmail -t

fi

#To be used with the following command added to xinitrc
#dbus-monitor "interface='org.freedesktop.Notifications'" | grep --line-buffered "string" | grep --line-buffered -e method -e ":" -e '""' -e urgency -e notify -v | grep --line-buffered '.*(?=string)|(?<=string).*' -oPi | grep --line-buffered -v '^\s*$' | xargs -I '{}' /bin/bash /home/thomas/scripts/notification-forwarding.sh {}