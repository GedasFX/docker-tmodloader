FROM debian:buster-slim

RUN apt update && \
    apt install -y curl wget tmux cron procps

RUN cron &

RUN addgroup --gid 1000 terraria && \
    adduser --system --shell /sbin/nologin --uid 1000 --ingroup terraria terraria && \
    ln -s /home/terraria/.local/share/Terraria /data
USER terraria

VOLUME /data
WORKDIR /server

COPY --chown=1000:1000 entrypoint.sh /
COPY --chown=1000:1000 run.sh /usr/local/bin/run

EXPOSE 7777
ENV TMLSERVER_AUTOSAVE_INTERVAL="*/10 * * * *"

ENTRYPOINT [ "/entrypoint.sh" ]
# ENTRYPOINT [ "tail", "/dev/null", "-f" ]