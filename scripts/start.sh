#!/bin/bash

[ ! -d "/data/server" ] && mkdir /data/server
[ ! -d "/data/tModLoader" ] && mkdir /data/tModLoader
[ ! -L "/home/tModLoader/.local/share/Terraria/tModLoader" ] &&
    mkdir -p /home/tModLoader/.local/share/Terraria &&
    cd /home/tModLoader/.local/share/Terraria &&
    ln -s /data/tModLoader tModLoader

cd /data/server

# STDOUT_PIPE=/tmp/tmod.out

# function shutdown() {
#     run "exit"
#     while [ -e "/proc/$TMLS_PID" ]; do
#         sleep .2
#     done
#     rm $STDOUT_PIPE
# }

if [ "$TMLSERVER_VERSION" != "$(cat current_version)" ]; then

    /scripts/download_server.sh
    echo "$TMLSERVER_VERSION" >current_version

fi

# Custom logic to handle the setup
if [ "$1" = "setup" ]; then
    exec ./start-tModLoaderServer.sh -nosteam
fi

# # Setup autosave
# [ -z "$(crontab -l)" ] && echo "$TMLSERVER_AUTOSAVE_INTERVAL /usr/local/bin/run 'say Autosaving!' && /usr/local/bin/run 'save'" | crontab -
# cron &

# trap shutdown SIGTERM SIGINT

# mkfifo $STDOUT_PIPE
# tmux new-session -d "./start-tModLoaderServer.sh -nosteam | tee $STDOUT_PIPE" &

# while [ -z "$TMLS_PID" ]; do
#     TMLS_PID=$(pgrep tModLoader)
#     sleep .2
# done

# tail --pid "$TMLS_PID" -n +1 -f /data/Logs/server.log &
# cat $STDOUT_PIPE &

# wait ${!}
