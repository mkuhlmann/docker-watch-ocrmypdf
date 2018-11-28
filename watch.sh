#!/bin/bash

RCLONE_CMD=''


. /appenv/bin/activate

inotifywait -m /consume -e create -e moved_to |
    while read path action file; do
        fullfile=/consume/$file
        extension="${file##*.}"
        filename="${file%.*}"

        if [ $extension != 'pdf' ]; then
            echo $file is an image. running img2pdf
            img2pdf $fullfile -o /tmp/out.pdf
            rm $fullfile
            fullfile=/tmp/out.pdf
            extension=pdf
        fi

        echo $file was created
        sleep 2s
        ocrmypdf $OCRWATCH_OCRMYPDF $fullfile /tmp/$filename.pdf
        
        cmd=$(echo $OCRWATCH_AFTER | sed "s|%FILE%|/tmp/$filename.pdf|")
        $cmd

        rm $fullfile
        
    done

