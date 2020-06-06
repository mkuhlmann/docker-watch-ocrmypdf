FROM jbarlow83/ocrmypdf:v9.8.2

RUN apt-get install inotify-tools curl unzip man-db -y && rm -rf /var/lib/apt/lists/*

RUN curl https://rclone.org/install.sh | bash

COPY ./watch.sh /
RUN chmod +x /watch.sh
ENTRYPOINT [ "/watch.sh" ]
