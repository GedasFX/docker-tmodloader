# tModLoader Docker Image

This docker image downloads and runs a tModLoader server in a docker image.

Features configurable auto-save functionality, and graceful saving (including `docker stop`).

To install mods, put them in the `/data/tModLoader/Mods` folder. Mods can be downloaded from the Steam Workshop. Downloaded mods will be placed in the `$STEAM_DIR/steamapps/workshop/content/1281930` directory. From there, mod files (`*.tmod`) can be copied over.

IMPORTANT NOTE: Due to the unstable nature of Mods in both multiplayer and Linux, some mods may not function properly. As an alternative, use Steam multiplayer instead.

## Features

### Version Select

Can easily swap between versions by changing the `TMLSERVER_VERSION` env variable. See below for examples.

### Autosaving

Auto saves the game. By default, this occurs every 10 minutes and can be customized by providing a custom cron expression to the `TMLSERVER_AUTOSAVE_INTERVAL` environment variable. The default value is `*/10 * * * *`.

### Easy log access

In 1.3, tModLoader did not like to print its logs to stdout for some reason, where this image fixed that issue. It is less of a problem in 1.4.

## Basic `docker run` use case

To run a specified tModLoader version, use the `TMODLOADER_VERSION` environment variable.

Example to run a 2022.09.47.1 tModLoader server:

```bash
docker run -it --rm --name tmlserver \
           -p 7777:7777 \
           -e TMLSERVER_VERSION=2022.09.47.1 \
           -v $(pwd)/data:/data \
       gedasfx/tmodloader-server
```

This will create a new server with TTY enabled which allows us to manually configure the server. 

To detach from the console while keeping the server running, press Ctrl-P, followed by Ctrl-Q. To reattach, run `docker attach tmlserver`.

### Running in daemon mode

While tModLoader 1.4 has made daemon mode mostly obsolete, it is still relevant, as it supports the ability to run commands externally and **autosaving**.

To run in daemon mode, first, edit or mount the configuration located in `/data/server/serverconfig.txt`. If the world file location is specified (see [serverconfig.txt](./serverconfig.txt) for PATH example), the server will start automatically. For other values, see the [configuration example](https://github.com/tModLoader/tModLoader/blob/1.4/patches/tModLoader/Terraria/release_extras/serverconfig.txt) provided by the development team.

An example of how to run the server in daemon mode while mounting the serverconfig.txt can be seen below.

```bash
docker run --rm -d --name tmlserver \
           -p 7777:7777 \
           -e TMLSERVER_VERSION=2022.09.47.1 \
           -v $(pwd)/data:/data \
           -v $(pwd)/serverconfig.txt:/data/server/serverconfig.txt \
       gedasfx/tmodloader-server daemon
```

#### Executing commands

The containers running in headless (daemon) do not accept user input. To run commands, the following alternative could be used:
```
docker exec tmlserver run "say Hello World!"
```
The logs (and command output) will appear in the standard output, and can be seen via:

```
docker logs tmlserver --tail 100 -f
```

### Legacy tModLoader 1.3

To enable support for v1.3 of tModLoader, use major version `1` of the image. Old documentation can be found on the [v1.3 branch]().

```bash
docker run --rm -d --name tmlserver \
           -p 7777:7777 \
           -e TMLSERVER_VERSION=0.11.8.5 \
           -v $(pwd)/tModLoader_data:/data \
           -v $(pwd)/tModLoader_server:/server \
           -v $(pwd)/serverconfig.txt:/server/serverconfig.txt \
       gedasfx/tmodloader-server:1
```

## With `docker-compose`

See the [docker-compose.yml](./docker-compose.yml) file for an example.
