FROM debian:buster-slim

RUN apt update && \
    apt install -y curl wget tmux cron procps

RUN ln -s /root/.local/share/Terraria/ModLoader /data

COPY entrypoint.sh /
COPY run.sh /usr/local/bin/run

EXPOSE 7777
ENV TMLSERVER_AUTOSAVE_INTERVAL="*/10 * * * *"

VOLUME [ "/server" ]
VOLUME [ "/data" ]

ENTRYPOINT [ "/entrypoint.sh" ]