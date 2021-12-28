#!/bin/bash

# Start Cron
cron &

# Run as unpriviledged user
exec setpriv --reuid=1000 --regid=1000 --init-groups /start.sh
