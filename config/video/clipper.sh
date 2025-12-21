#!/usr/bin/env bash
set -euo pipefail

replay_dir="~/Videos/Replay"
mp4_dir="$replay_dir/mp4"

latest_file="$(
  find "$replay_dir" -maxdepth 1 -type f -name 'Replay *.mkv' \
  | sort \
  | tail -n 1
)"

video-trimmer "$latest_file"

base_name="$(basename "$latest_file" .mkv)"
trimmed_file="$replay_dir/$base_name (trimmed).mkv"

date_part="${base_name#Replay }"
output_mp4="$mp4_dir/$date_part.mp4"

tomp4 "$trimmed_file" "$output_mp4"
