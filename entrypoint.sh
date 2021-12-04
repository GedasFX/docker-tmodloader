#!/bin/bash

GITHUB_URL='https://github.com/tModLoader/tModLoader/releases/'

# Extract version
version=`echo $LOADER_VERSION | tr '[:upper:]' '[:lower:]'`

if [ "$version" = 'latest' ]
then
    version=`curl -I "${GITHUB_URL}/latest" | grep -Fi "location: " | awk -F / '{print $NF}'`
fi

echo $version
