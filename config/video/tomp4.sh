# ~/.local/bin/tomp4
#!/usr/bin/env bash
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: tomp4 <path to mkv> <path to mp4>"
    exit 1
fi

ffmpeg -i "$1" -c:v copy -c:a copy "$2"
