# tModLoader Docker Image

This docker image downloads and runs a tModLoader server in a docker image. Uses Ubuntu as base to mitigate stability issues.

## Basic `docker run` use case

To run a specified tModLoader version, use `TMODLOADER_VERSION` environment variable.

Example to run a 0.11.8.5 tModLoader server

```
docker run -it --rm \
           -p 7777:7777 \
           -e TMODLOADER_VERSION=v0.11.8.5 \
           -v $(pwd)/tModLoader_server_files:/root/.local/share/Terraria \
       gedasfx/tmodloader-server
```

## With `docker-compose`

See [docker-compose.yml](./docker-compose.yml) file for an example.
