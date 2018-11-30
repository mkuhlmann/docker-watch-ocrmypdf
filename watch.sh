#!/bin/bash

. /appenv/bin/activate

inotifywait -m /consume -e create -e moved_to |
    while read path action file; do
        fullfile=/consume/$file
        extension="${file##*.}"
        filename="${file%.*}"

        echo "$file was created. extension=$extension filename=$filename"

        filesize=$(stat -c%s $fullfile)
        echo "sleeping 2s"
        sleep 2

        while [[ $filesize -lt $(stat -c%s $fullfile) ]]; do
            filesize=$(stat -c%s $fullfile)
            echo "waiting for transfer to finish (size=$filesize)"
            sleep 2
        done

        if [[ ! "$extension" =~ ^(pdf|jpg|jpeg|png|PDF|JPG|JPEG|PNG)$ ]]; then
            echo $extension is not supported. Skipping.
            continue
        fi

        if [ $extension != 'pdf' ]; then
            echo $file is an image. running img2pdf
            img2pdf $fullfile -o /tmp/out.pdf
            rm $fullfile
            fullfile=/tmp/out.pdf
            extension=pdf
        fi


        after_cmd=$(echo $OCRWATCH_AFTER | sed "s|%FILE%|/tmp/$filename.pdf|")

        if [ ! -z "$OCRWATCH_IGNOREOCR" ]; then
            if [[ $filename =~ $OCRWATCH_IGNOREOCR ]]; then
                echo "filename matches OCRWATCH_IGNOREOCR, skipping ocr"
                mv $fullfile /tmp/$filename.pdf
                $after_cmd
                continue                
            fi
        fi

        ocrmypdf $OCRWATCH_OCRMYPDF $fullfile /tmp/$filename.pdf
        $after_cmd
        rm $fullfile
        
    done

