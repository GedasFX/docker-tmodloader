FROM ubuntu:20.04

ENV LOADER_VERSION=LATEST

WORKDIR /tmodloader
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

ENTRYPOINT [ "./entrypoint.sh" ]