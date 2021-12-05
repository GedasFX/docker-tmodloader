#!/bin/bash

STDOUT_PIPE=/tmp/tmod.out

function shutdown() {
    run "exit"
    TMLS_PID=$(pgrep tModLoader)
    while [ -e "/proc/$TMLS_PID" ]; do
        sleep .2
    done
    rm $STDOUT_PIPE
}

if [ ! -f "version_locked" ]; then
    GITHUB_URL='https://github.com/tModLoader/tModLoader/releases'

    LOADER_TAR_FILE_NAME="tModLoader.Linux.v$TMLSERVER_VERSION.tar.gz"
    LOADER_DL_URL="https://github.com/tModLoader/tModLoader/releases/download/v$TMLSERVER_VERSION/$LOADER_TAR_FILE_NAME"

    if [ "$(curl -I "$LOADER_DL_URL" -s -o /dev/null -w "%{http_code}")" -ge 400 ]; then
        echo "Unknown loader version. See latest version at $GITHUB_URL/latest. Do not include the v before the number."
        exit 1
    fi

    wget -c "$LOADER_DL_URL"
    tar -xz -f "$LOADER_TAR_FILE_NAME"

    # Setup autosave
    (crontab -l 2>/dev/null; echo "$TMLSERVER_AUTOSAVE_INTERVAL /usr/local/bin/run 'say Autosaving!' && /usr/local/bin/run 'save'") | crontab -

    # Mark init as complete
    touch version_locked
fi

# Custom logic to handle the setup
if [ "$1" = "setup" ]; then
    exec ./tModLoaderServer
fi

trap shutdown SIGTERM SIGINT

mkfifo $STDOUT_PIPE
tmux new-session -d "./tModLoaderServer -config serverconfig.txt | tee $STDOUT_PIPE" &
sleep 60 && cron &
cat $STDOUT_PIPE &
wait ${!}
