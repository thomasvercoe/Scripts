#!/bin/bash


#do logic to find files with same inode


echo "called deluge_remove.sh for $2" >> /tmp/deluge_remove.sh.log

x="$2"
y="$3"

ARG_DIR="$y"
ARG_PATH="$y/$x"
ARG_NAME="$x"
ARG_LABEL="N/A"


permission_fix () {
    echo "fixing permissions" >> /tmp/deluge_remove.sh.log
    chmod -R 777 /data/thomas
}


permissions_fix

if [ -d "$ARG_PATH" ] 
then
    echo "$ARG_PATH is a directory" >> /tmp/deluge_remove.sh.log
    shopt -s nullglob
    for file in "$ARG_PATH/"*
    do
        inum="$(ls -i "$file" | head -n1 | awk '{print $1;}')"
        echo "removing file $file with inode $inum" >> /tmp/deluge_remove.sh.log
        find /data/thomas -inum $inum -delete
    done
    shopt -u nullglob

    echo "removing directory $ARG_PATH" >> /tmp/deluge_remove.sh.log
    rm -r "$ARG_PATH"

else

    inum="$(ls -i "$ARG_PATH" | head -n1 | awk '{print $1;}')"
    echo "removing file $ARG_PATH" >> /tmp/deluge_remove.sh.log
    find /data/thomas -inum $inum -delete

fi


echo "cleaning empty directories" >> /tmp/deluge_remove.sh.log

repeat=$(($(find /data/thomas/media -type d -printf '%d\n' | sort -rn | head -1)))

for i in $(seq $(($repeat)))
do
    find "/data/thomas/media/Anime" -not -path "/data/thomas/media/Anime" -type d -empty -delete
    find "/data/thomas/media/Books" -not -path "/data/thomas/media/Books" -type d -empty -delete
    find "/data/thomas/media/Movies" -not -path "/data/thomas/media/Movies" -type d -empty -delete
    find "/data/thomas/media/Music" -not -path "/data/thomas/media/Music" -type d -empty -delete
    find "/data/thomas/media/TV Shows" -not -path "/data/thomas/media/TV Shows" -type d -empty -delete
done


permissions_fix

echo "running jellyfin rescan" >> /tmp/deluge_remove.sh.log

curl -v -d "" -H "X-MediaBrowser-Token: 50b2821357244e229265c7f967dcd174" http://127.0.0.1:8096/library/refresh

echo "exiting" >> /tmp/deluge_remove.sh.log