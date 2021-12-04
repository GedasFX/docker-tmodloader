FROM ubuntu:20.04

RUN apt update && \
    apt install -y curl wget

RUN useradd -m tmodloader
USER tmodloader
WORKDIR /home/tmodloader

RUN mkdir -p /home/tmodloader/.local/share/Terraria/
VOLUME [ "/home/tmodloader/.local/share/Terraria/" ]

COPY --chown=tmodloader:tmodloader entrypoint.sh .

ENTRYPOINT [ "./entrypoint.sh" ]