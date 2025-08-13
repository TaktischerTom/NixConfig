# ~/.local/bin/mc
#!/usr/bin/env bash
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: mc <start|stop|restart|status> <server>"
    exit 1
fi

systemctl "$1" "minecraft-server-$2"
