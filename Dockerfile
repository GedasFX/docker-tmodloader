FROM debian:buster-slim

RUN apt update && \
    apt install -y gosu libicu63 curl wget tmux cron procps unzip

RUN groupadd -r tModLoader -g 1000 && \
    useradd -u 1000 -r -g tModLoader -m tModLoader

# RUN  && chown -h tModLoader:tModLoader /data/tModLoader
#     # ln -s /tModLoader/server /data/server && chown -h tModLoader:tModLoader /data/server

COPY scripts/ /scripts/

COPY entrypoint.sh /
COPY scripts/run.sh /usr/local/bin/run
COPY scripts/run-user.sh /usr/local/bin/run-user

EXPOSE 7777
ENV TMLSERVER_AUTOSAVE_INTERVAL="* * * * *"

VOLUME [ "/data" ]

ENTRYPOINT [ "/entrypoint.sh" ]