FROM debian:buster-slim

RUN apt update && \
    apt install -y curl wget tmux cron procps

RUN addgroup --gid 1000 terraria && \
    adduser --system --shell /dev/null --uid 1000 --ingroup terraria terraria && \
    ln -s /home/terraria/.local/share/Terraria /data && \
    install -o 1000 -g 1000 -d /server

COPY --chown=1000:1000 start.sh /
COPY --chown=1000:1000 entrypoint.sh /
COPY --chown=1000:1000 run.sh /usr/local/bin/run

EXPOSE 7777
ENV TMLSERVER_AUTOSAVE_INTERVAL="*/10 * * * *"

VOLUME [ "/server" ]
VOLUME [ "/data" ]

#ENTRYPOINT [ "/entrypoint.sh" ]
 ENTRYPOINT [ "tail", "/dev/null", "-f" ]