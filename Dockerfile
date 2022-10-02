FROM debian:buster-slim

RUN apt update && \
    apt install -y gosu libicu63 curl wget tmux cron procps unzip

RUN groupadd -r tModLoader -g 1000 && \
    useradd -u 1000 -r -g tModLoader -m tModLoader

COPY scripts/ /scripts/

COPY entrypoint.sh /
COPY run.sh /usr/local/bin/run

EXPOSE 7777
ENV TMLSERVER_AUTOSAVE_INTERVAL="*/10 * * * *"

VOLUME [ "/data" ]

ENTRYPOINT [ "/entrypoint.sh" ]