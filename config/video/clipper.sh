#!/usr/bin/env bash
set -euo pipefail

replay_dir="$HOME/Videos/Replay"
mp4_dir="$replay_dir/mp4"

custom_name=""
original_ws="$(hyprctl activeworkspace -j | grep -o '"id":[[:space:]]*[0-9]*' | cut -d: -f2 | tr -d '[:space:]')"


while [[ $# -gt 0 ]]; do
  case "$1" in
    -n|--name)
      [[ $# -ge 2 ]] || { echo "Missing value for $1" >&2; exit 1; }
      custom_name="$2"
      shift 2
      ;;
    -*)
      echo "Unknown option: $1" >&2
      exit 1
      ;;
    *)
      break
      ;;
  esac
done

if [[ $# -eq 1 ]]; then
  latest_file="$1"
elif [[ $# -eq 0 ]]; then
  latest_file="$(
    find "$replay_dir" -maxdepth 1 -type f -name 'Replay *.mkv' \
    | sort \
    | tail -n 1
  )"
else
  echo "Usage: $0 [-n|--name name] [path-to-replay.mkv]" >&2
  exit 1
fi

video-trimmer "$latest_file"

base_name="$(basename "$latest_file" .mkv)"
trimmed_file="$replay_dir/$base_name (trimmed).mkv"

if [[ -n "$custom_name" ]]; then
  output_mp4="$mp4_dir/$custom_name.mp4"
else
  date_part="${base_name#Replay }"
  output_mp4="$mp4_dir/$date_part.mp4"
fi

tomp4 "$trimmed_file" "$output_mp4"

rm -- "$trimmed_file"

hyprctl dispatch workspace "$original_ws"
