#!/bin/bash

GITHUB_URL='https://github.com/tModLoader/tModLoader/releases'

if [ ! -f "version_locked" ]; then
    # Extract version

    LOADER_VERSION=`echo $TMODLOADER_VERSION | tr '[:upper:]' '[:lower:]'`

    LOADER_TAR_FILE_NAME="tModLoader.Linux.$LOADER_VERSION.tar.gz"
    LOADER_DL_URL="https://github.com/tModLoader/tModLoader/releases/download/$LOADER_VERSION/$LOADER_TAR_FILE_NAME"

    if [ `curl -I $LOADER_DL_URL -s -o /dev/null -w "%{http_code}"` -ge 400 ]
    then
        echo "Unknown loader version. See latest version at $GITHUB_URL/latest"
        exit 1
    fi

    wget -c $LOADER_DL_URL
    tar -xz -f $LOADER_TAR_FILE_NAME

    touch version_locked
fi

if [ "$#" -gt 0 ]; then
    ./tModLoaderServer $0
elif [ -f "serverconfig.cfg" ]; then
    ./tModLoaderServer -config serverconfig.cfg
else
    ./tModLoaderServer
fi
