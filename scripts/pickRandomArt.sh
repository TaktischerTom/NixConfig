# ~/.local/bin/mc
#!/usr/bin/env bash

art_dir="$HOME/SystemConfig/scripts/ascii_art"

random_file=$(find "$art_dir" -maxdepth 1 -type f -name "*.txt" | shuf -n 1)

cat "$random_file"