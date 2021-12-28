# tModLoader Docker Image

This docker image downloads and runs a tModLoader server in a docker image.

Features configurable auto save functionality, and graceful saving (including `docker stop`).

## Features

### Version Select

Can easily swap between versions by changing the `TMLSERVER_VERSION` env variable. See below for examples.

### Autosaving

Auto saves the game. By default this occurs every 10 minutes, can be customized by providing a custom cron expression to the `TMLSERVER_AUTOSAVE_INTERVAL` env variable. Default value can be found on the [Dockerfile](Dockerfile).

### Easy log access

tModLoader does not like to print its logs to stdout for some reason, this image fixes that.

## Basic `docker run` use case

To run a specified tModLoader version, use `TMODLOADER_VERSION` environment variable.

Example to run a 0.11.8.5 tModLoader server

```
docker run -it --rm \
           -p 7777:7777 \
           -e TMLSERVER_VERSION=0.11.8.5 \
           -v $(pwd)/tModLoader_data:/data \
           -v $(pwd)/tModLoader_server:/server \
       gedasfx/tmodloader-server setup
```

### Running with a config file

This is the recommended way of running the server

```
docker run --rm -d --name tmlserver \
           -p 7777:7777 \
           -e TMLSERVER_VERSION=0.11.8.5 \
           -v $(pwd)/tModLoader_data:/data \
           -v $(pwd)/tModLoader_server:/server \
           -v $(pwd)/serverconfig.txt:/server/serverconfig.txt \
       gedasfx/tmodloader-server
```

### Executing commands

The container runs in headless mode and does not accept accept user input. To run commands, the following can be used:
```
docker exec tmlserver run <command>
```
The logs (and command output) appears in the standard output, and can be seen via:

```
docker logs tmlserver --tail 100 -f
```

## With `docker-compose`

See [docker-compose.yml](https://github.com/GedasFX/tmodloader/blob/master/docker-compose.yml) file for an example.

