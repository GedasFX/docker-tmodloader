FROM ubuntu:20.04

RUN apt update && \
    apt install -y curl wget tmux cron

RUN ln -s /root/.local/share/Terraria /data
VOLUME [ "/data" ]

WORKDIR /server

COPY entrypoint.sh .
COPY run.sh /usr/local/bin/run

EXPOSE 7777
ENV TMLSERVER_AUTOSAVE_INTERVAL="*/10 * * * *"

ENTRYPOINT [ "./entrypoint.sh" ]