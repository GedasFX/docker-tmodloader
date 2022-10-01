#!/bin/bash

GITHUB_URL='https://github.com/tModLoader/tModLoader/releases'
LOADER_DL_URL="https://github.com/tModLoader/tModLoader/releases/download/v$TMLSERVER_VERSION/tModLoader.zip"

if [ "$(curl -I "$LOADER_DL_URL" -s -o /dev/null -w "%{http_code}")" -ge 400 ]; then
    echo "Unknown loader version. See latest version at $GITHUB_URL/latest."
    exit 1
fi

wget -c "$LOADER_DL_URL"
unzip -o "tModLoader.zip"
rm "tModLoader.zip"
chmod +x "./start-tModLoaderServer.sh"
