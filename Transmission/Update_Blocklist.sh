#!/bin/sh

PID="`pidof transmission-daemon`"
if [ -n "$PID" ]; then
        kill $PID
fi

echo -n "Waiting for the daemon to exit "
sleep 2

COUNT=1
while [ -n "`pidof transmission-daemon`" ]; do
        COUNT=$((COUNT + 1))
        if [ $COUNT -gt 60 ]; then
                echo -n "transmission-daemon doesn't respond, killing it with -9"
                kill -9 `pidof transmission-daemon`
                break
        fi

        sleep 2
        echo -n "."
done

echo " done"

cd /var/lib/transmission-daemon/info/blocklists/
if wget http://john.bitsurge.net/public/biglist.p2p.gz 1>/dev/null 2>&1 ; then
        rm -f biglist.p2p && gunzip biglist.p2p.gz
        echo "blocklist updated"
else
        echo "blocklist not updated"
fi

/bin/systemctl start transmission-daemon
