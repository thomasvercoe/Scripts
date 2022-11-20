#!/bin/bash

#x="A.Grin.Without.a.Cat.1of2.Fragile.Hands.x264.AC3.MVGroup.org.mkv"
#y='/data/thomas/torrents/completed/shows'

x="$2"
y="$3"


ARG_DIR="$y"
ARG_PATH="$y/$x"
ARG_NAME="$x"
ARG_LABEL="N/A"

log='/tmp/media_manager.sh.log'

echo "[$(date +"%T")] called media_manager.sh for $x" >> $log


permission_fix () {
    echo "[$(date +"%T")] fixing permissions" >> $log
    chmod -R 777 /data/thomas
}


jellyfin_rescan () {
    permission_fix
    echo "[$(date +"%T")] running jellyfin rescan" >> $log
    curl -v -d "" -H "X-MediaBrowser-Token: 50b2821357244e229265c7f967dcd174" http://127.0.0.1:8096/library/refresh 2>&1 | sed "s/^/[$(date +"%T")] -> /" >> $log
}

exiting () {
    permission_fix
    echo "[$(date +"%T")] backing up torrent_files to torrent_files_archive" >> $log
    echo "[$(date +"%T")] copying torrent_files to torrent_files_archive_tmp" >> $log
    cp -r "/data/thomas/torrents/torrent_files" "/home/thomas/Downloads/torrent_files_archive_tmp"
    echo "[$(date +"%T")] fixing permisions for torrent_files_archive_tmp" >> $log
    chmod -R 777 /home/thomas/Downloads/torrent_files_archive_tmp
    echo "[$(date +"%T")] moving torrent_files_archive_tmp to torrent_files_archive" >> $log
    rm -r "/home/thomas/Downloads/torrent_files_archive"
    mv "/home/thomas/Downloads/torrent_files_archive_tmp" "/home/thomas/Downloads/torrent_files_archive"
    echo "[$(date +"%T")] fixing permisions for torrent_files_archive" >> $log
    chmod -R 777 /home/thomas/Downloads/torrent_files_archive
    echo "[$(date +"%T")] cleaning torrent_files_archive_tmp" >> $log
    #rm -r "/home/thomas/Downloads/torrent_files_archive_tmp"
    jellyfin_rescan
    echo "[$(date +"%T")] exiting" >> $log
    exit
}

anidb_cli () {
    echo "[$(date +"%T")] passing to anidbcli" >> $log
    permission_fix
    python3.9 -m anidbcli  -r -e mkv,mp4 api -u "api_username" -p "Anidb2141" -sr "/data/thomas/media/Anime/%a_english%/%ep_no% - %ep_english%" "/data/thomas/torrents/completed/anime_tmp" | sed "s/^/[$(date +"%T")] -> /" >> $log
}




permission_fix

#shows
if [[ $ARG_DIR == '/data/thomas/torrents/completed/shows' ]]
then
    echo "[$(date +"%T")] asigning to shows" >> $log
    ARG_LABEL="TV"

    echo "[$(date +"%T")] Running Filebot amc script" >> $log
    filebot -script fn:amc --output "/data/thomas/media" --action hardlink --conflict skip -non-strict --log-file /tmp/amc.log --def unsorted=n music=n artwork=n excludeList=amc.txt ut_dir="$ARG_PATH" ut_kind="multi" ut_title="$ARG_NAME" ut_label="$ARG_LABEL" | sed "s/^/[$(date +"%T")] -> /" >> $log


#films
elif [[ $ARG_DIR == '/data/thomas/torrents/completed/films' ]]
then
    echo "[$(date +"%T")] asigning to films" >> $log
    ARG_LABEL="Movies"

    echo "[$(date +"%T")] Testing if HDR" >> $log
    HDR_TEST="$(mediainfo --Inform="Video;%HDR_Format%" "$ARG_PATH")"
    echo "[$(date +"%T")] Testing if Blue-ray Disk" >> $log
    BD_TEST="$(find "$ARG_PATH" -name BDMV)"

    echo "[$(date +"%T")] Running Filebot amc script" >> $log
    filebot -script fn:amc --output "/data/thomas/media" --action hardlink --conflict skip -non-strict --log-file /tmp/amc.log --def unsorted=n music=n artwork=n excludeList=amc.txt ut_dir="$ARG_PATH" ut_kind="multi" ut_title="$ARG_NAME" ut_label="$ARG_LABEL" "movieFormat=/data/thomas/media/Movies/{n} ({y})//{n} ({y}) [T3mp]" | sed "s/^/[$(date +"%T")] -> /" >> $log

    permission_fix

    #I'm sure there is a better way to do this. I don't know it tho :(
    NEW_LOCATION=$(find /data/thomas/media/Movies -name '*T3mp*')
    
    #Tagging as HDR Blue-ray Disk or leaving alone
    if [ "$HDR_TEST" != '' ]
    then
        echo "[$(date +"%T")] Tagging as HDR" >> $log
        mv "$NEW_LOCATION" "${NEW_LOCATION//' [T3mp]'/' [HDR]'}" 2>&1 | sed "s/^/[$(date +"%T")] -> /" >> $log

    elif [[ "$BD_TEST != '' ]]
    then
        echo "[$(date +"%T")] Tagging as a Blue-ray Disk" >> $log
        mv "$NEW_LOCATION" "${NEW_LOCATION//' [T3mp]'/' [BD]'}" 2>&1 | sed "s/^/[$(date +"%T")] -> /" >> $log

    else
        echo "[$(date +"%T")] Leaving untagged" >> $log
        mv "$NEW_LOCATION" "${NEW_LOCATION//' [T3mp]'/}" 2>&1 | sed "s/^/[$(date +"%T")] -> /" >> $log
    fi



#music
elif [[ $ARG_DIR == '/data/thomas/torrents/completed/music' ]]
then
    echo "[$(date +"%T")] asigning to music" >> $log
    ARG_LABEL="Music"

    echo "[$(date +"%T")] Running Filebot amc script" >> $log
    filebot -script fn:amc --output "/data/thomas/media" --action hardlink --conflict skip -non-strict --log-file /tmp/amc.log --def unsorted=n music=y artwork=n excludeList=amc.txt ut_dir="$ARG_PATH" ut_kind="multi" ut_title="$ARG_NAME" ut_label="$ARG_LABEL" | sed "s/^/[$(date +"%T")] -> /" >> $log



#anime
elif [[ $ARG_DIR == "/data/thomas/torrents/completed/anime" ]]
then
    echo "[$(date +"%T")] asigning to anime" >> $log
    hardlink="/data/thomas/torrents/completed/anime_tmp/$ARG_NAME"
    permission_fix
    
    if [ -d "/data/thomas/torrents/completed/anime/$ARG_NAME" ] 
    then
        echo "[$(date +"%T")] the torrent contains a directory, attempting to hardlink files from within the first directory" >> $log
        mkdir "/data/thomas/torrents/completed/anime_tmp/$ARG_NAME"
        permission_fix
        shopt -s nullglob
        for file in "/data/thomas/torrents/completed/anime/$ARG_NAME/"*
        do
            echo "[$(date +"%T")] $file" >> $log
            file_base="$(basename "$file")"
            echo "[$(date +"%T")] hardlinking files to anime_tmp" >> $log
            ln "$file" "$hardlink/$file_base"
        done
        shopt -u nullglob

        anidb_cli

    else
        echo "[$(date +"%T")] the torrent does not contain a directory, attempting to hardlink file" >> $log
        ln "$ARG_PATH" "$hardlink"
        anidb_cli
    fi

    permission_fix

    echo "[$(date +"%T")] cleaning anime_tmp" >> $log
    find "/data/thomas/torrents/completed/anime_tmp" -not -path "/data/thomas/torrents/completed/anime_tmp" -type d -empty -delete


#books
elif [[ $ARG_DIR == '/data/thomas/torrents/completed/books' ]]
then
    echo "[$(date +"%T")] asigning to books" >> $log
    hardlink="/data/thomas/torrents/completed/books_tmp/$ARG_NAME"

    echo "[$(date +"%T")] processing" >> $log

    cp -r "$ARG_PATH" "$hardlink"

    echo "[$(date +"%T")] adding to calibre database" >> $log
    calibredb add -r "$hardlink" | sed "s/^/[$(date +"%T")] -> /" >> $log

    echo "[$(date +"%T")] cleaning books_tmp" >> $log
    rm -r "$hardlink"

    exiting

#audiobooks
elif [[ $ARG_DIR == '/data/thomas/torrents/completed/audiobooks' ]]
then
    echo "[$(date +"%T")] asigning to audiobooks" >> $log
    hardlink="/data/thomas/media/Audiobooks/$ARG_NAME"

    echo "[$(date +"%T")] processing" >> $log

    ln "$ARG_PATH" "$hardlink"

    exiting

else
    echo "[$(date +"%T")] not assigned" >> $log
    exiting
fi

exiting