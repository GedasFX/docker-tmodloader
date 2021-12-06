# tModLoader Docker Image

This docker image downloads and runs a tModLoader server in a docker image. Uses Ubuntu as base to mitigate stability issues.

Features configurable auto save functionality, and graceful saving (including `docker stop`).

## Basic `docker run` use case

To run a specified tModLoader version, use `TMODLOADER_VERSION` environment variable.

Example to run a 0.11.8.5 tModLoader server

```
docker run -it --rm \
           -p 7777:7777 \
           -e TMLSERVER_VERSION=0.11.8.5 \
           -v $(pwd)/tModLoader_data:/data \
       gedasfx/tmodloader-server setup
```

### Running with a config file

This is the recommended way of running the server

```
docker run --rm -d --name tmlserver \
           -p 7777:7777 \
           -e TMLSERVER_VERSION=0.11.8.5 \
           -v $(pwd)/tModLoader_data:/data \
           -v $(pwd)/serverconfig.txt:/server/serverconfig.txt \
       gedasfx/tmodloader-server
```

### Executing commands

The container in headless mode does not accept accept user input. To run commands, the following can be used:
```
docker exec tmlserver run <command>
```
The logs (and command output) appears in the standard output, and can be seen via:

```
docker logs tmlserver --tail 100 -f
```

## With `docker-compose`

See [docker-compose.yml](https://github.com/GedasFX/tmodloader/blob/master/docker-compose.yml) file for an example.
