#!/bin/bash

if [[ $(stat -c "%u" /data) != "1000" ]]; then
    echo "Changing ownership of /data to 1000 ..."
    chown -R tModLoader:tModLoader /data
fi

if [ "$TMLSERVER_VERSION" == v* ]; then
    TMLSERVER_VERSION="${TMLSERVER_VERSION:1}"
fi

# # Setup autosave
[ -z "$(crontab -l)" ] && echo "$TMLSERVER_AUTOSAVE_INTERVAL /usr/local/bin/run 'say Autosaving!' && /usr/local/bin/run 'save'" | crontab -
cron

exec gosu tModLoader:tModLoader "/scripts/start.sh" "$@"
