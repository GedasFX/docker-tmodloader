#!/bin/bash

if [[ $(stat -c "%u" /data) != "1000" ]]; then
    echo "Changing ownership of /data to 1000 ..."
    chown -R tModLoader:tModLoader /data
fi

if [ "$TMLSERVER_VERSION" == v* ]; then
    TMLSERVER_VERSION="${TMLSERVER_VERSION:1}"
fi

# # Setup autosave
[ ! -f "/etc/cron.d/autosave" ] &&
    echo "$TMLSERVER_AUTOSAVE_INTERVAL /scripts/autosave.sh" >/etc/cron.d/autosave &&
    crontab -u tModLoader /etc/cron.d/autosave &&
    chmod u+s /usr/sbin/cron

exec gosu tModLoader:tModLoader "/scripts/start.sh" "$@"
