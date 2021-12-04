FROM ubuntu:20.04

RUN apt update && \
    apt install -y curl wget

VOLUME [ "/root/.local/share/Terraria/" ]

WORKDIR /root
COPY entrypoint.sh .
ENTRYPOINT ./entrypoint.sh