FROM jbarlow83/ocrmypdf

USER root
RUN apt-get install inotify-tools curl unzip man-db -y

RUN curl https://rclone.org/install.sh | bash

COPY ./watch.sh /

RUN chmod +x /watch.sh
USER docker
ENTRYPOINT [ "/watch.sh" ]