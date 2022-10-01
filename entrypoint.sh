#!/bin/bash

cd /server || exit

STDOUT_PIPE=/tmp/tmod.out

function shutdown() {
    run "exit"
    while [ -e "/proc/$TMLS_PID" ]; do
        sleep .2
    done
    rm $STDOUT_PIPE
}

if [ "$TMLSERVER_VERSION" == v* ]; then
    TMLSERVER_VERSION="${TMLSERVER_VERSION:1}"
fi

GITHUB_URL='https://github.com/tModLoader/tModLoader/releases'

if [ "$TMLSERVER_LEGACY" ]; then

    if [ "$TMLSERVER_VERSION" != "$(cat current_version)" ]; then

        LOADER_TAR_FILE_NAME="tModLoader.Linux.v$TMLSERVER_VERSION.tar.gz"
        LOADER_DL_URL="https://github.com/tModLoader/tModLoader/releases/download/v$TMLSERVER_VERSION/$LOADER_TAR_FILE_NAME"

        if [ "$(curl -I "$LOADER_DL_URL" -s -o /dev/null -w "%{http_code}")" -ge 400 ]; then
            echo "Unknown loader version. See latest version at $GITHUB_URL/latest."
            exit 1
        fi

        wget -c "$LOADER_DL_URL"
        tar -xz -f "$LOADER_TAR_FILE_NAME"

        echo "$TMLSERVER_VERSION" > current_version
    fi

    # Setup autosave
    [ -z "$(crontab -l)" ] && echo "$TMLSERVER_AUTOSAVE_INTERVAL /usr/local/bin/run 'say Autosaving!' && /usr/local/bin/run 'save'" | crontab -
    cron &

    # Custom logic to handle the setup
    if [ "$1" = "setup" ]; then
        exec ./tModLoaderServer
    fi

    trap shutdown SIGTERM SIGINT

    mkfifo $STDOUT_PIPE
    tmux new-session -d "./tModLoaderServer -config serverconfig.txt | tee $STDOUT_PIPE" &

else

    if [ "$TMLSERVER_VERSION" != "$(cat current_version)" ]; then
        GITHUB_URL='https://github.com/tModLoader/tModLoader/releases'

        LOADER_DL_URL="https://github.com/tModLoader/tModLoader/releases/download/v$TMLSERVER_VERSION/tModLoader.zip"

        if [ "$(curl -I "$LOADER_DL_URL" -s -o /dev/null -w "%{http_code}")" -ge 400 ]; then
            echo "Unknown loader version. See latest version at $GITHUB_URL/latest."
            exit 1
        fi

        wget -c "$LOADER_DL_URL"
        unzip "tModLoader.zip"

        echo "$TMLSERVER_VERSION" >current_version
    fi

    # Setup autosave
    [ -z "$(crontab -l)" ] && echo "$TMLSERVER_AUTOSAVE_INTERVAL /usr/local/bin/run 'say Autosaving!' && /usr/local/bin/run 'save'" | crontab -
    cron &

    # Custom logic to handle the setup
    if [ "$1" = "setup" ]; then
        exec ./tModLoader/start-tModLoaderServer.sh -nosteam
    fi

    trap shutdown SIGTERM SIGINT

    mkfifo $STDOUT_PIPE
    tmux new-session -d "./tModLoader/start-tModLoaderServer.sh -nosteam | tee $STDOUT_PIPE" &

fi

while [ -z "$TMLS_PID" ]; do
    TMLS_PID=$(pgrep tModLoader)
    sleep .2
done

tail --pid "$TMLS_PID" -n +1 -f /data/Logs/server.log &
cat $STDOUT_PIPE &

wait ${!}
