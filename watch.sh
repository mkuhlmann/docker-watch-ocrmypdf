#!/bin/bash

. /appenv/bin/activate

inotifywait -m /consume -e create -e moved_to |
    while read path action file; do
        fullfile=/consume/$file
        extension="${file##*.}"
        filename="${file%.*}"

        echo $file was created

        if [[ ! "$extension" =~ ^(pdf|jpg|jpeg|png|PDF|JPG|JPEG|PNG)$ ]]; then
            echo $extension is not supported. Skipping.
            continue
        fi

        sleep 5
        # @TODO use lsof to see if file is still being written

        if [ $extension != 'pdf' ]; then
            echo $file is an image. running img2pdf
            img2pdf $fullfile -o /tmp/out.pdf
            rm $fullfile
            fullfile=/tmp/out.pdf
            extension=pdf
        fi

        ocrmypdf $OCRWATCH_OCRMYPDF $fullfile /tmp/$filename.pdf
        
        cmd=$(echo $OCRWATCH_AFTER | sed "s|%FILE%|/tmp/$filename.pdf|")
        $cmd

        rm $fullfile
        
    done

