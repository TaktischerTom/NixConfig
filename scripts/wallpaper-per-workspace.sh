#!/usr/bin/env bash
#
# Per-workspace wallpapers for Hyprland, rendered by awww (the swww fork).
#
#   wallpaper-per-workspace apply
#       Re-point every monitor at the image for its active workspace.
#   wallpaper-per-workspace resolve <monitor> <workspace>
#       Print the image that would be used.
#   wallpaper-per-workspace status
#       Print the configured mapping, transition and lock screen sync.
#
set -euo pipefail

: "${WALLPAPERS_CONFIG:?WALLPAPERS_CONFIG is not set, use the wallpaper-per-workspace wrapper from modules/desktop/wallpapers.nix}"
# shellcheck source=/dev/null
source "$WALLPAPERS_CONFIG"

USAGE='usage: wallpaper-per-workspace <apply|resolve <monitor> <workspace>|status>'

log() { printf 'wallpaper-per-workspace: %s\n' "$*" >&2; }

daemon_socket() {
    printf '%s/%s-awww-daemon.sock' "${XDG_RUNTIME_DIR:-/tmp}" "${WAYLAND_DISPLAY:-wayland-1}"
}

ensure_daemon() {
    if awww query >/dev/null 2>&1; then
        return 0
    fi

    rm -f "$(daemon_socket)"
    nohup awww-daemon >/dev/null 2>&1 &

    for _ in {1..50}; do
        if awww query >/dev/null 2>&1; then
            return 0
        fi
        sleep 0.1
    done

    log "awww-daemon is not answering on $(daemon_socket)"
    return 1
}

displayed_images() {
    awww query 2>/dev/null | awk -F': ' '
        /currently displaying: image: / {
            print $2 "\t" substr($0, index($0, "currently displaying: image: ") + 29)
        }'
}

monitors() {
    hyprctl -j monitors |
        jq -r '.[] | select(.disabled == false)
                   | [.name, (.activeWorkspace.id | tostring), (.focused | tostring)]
                   | @tsv'
}

resolve_image() {
    local key="$1:$2" value
    value="${WALLPAPERS_MAP[$key]:-}"

    if [[ -z $value ]]; then
        key="$1:*"
        value="${WALLPAPERS_MAP[$key]:-}"
    fi

    if [[ -z $value ]]; then
        value="${WALLPAPERS_DEFAULT:-}"
    fi

    printf '%s' "$value"
}

set_wallpaper() {
    local monitor="$1" image="$2"

    awww img -o "$monitor" \
        --resize "${WALLPAPERS_RESIZE:-crop}" \
        --transition-type "${WALLPAPERS_TRANSITION[type]:-fade}" \
        --transition-duration "${WALLPAPERS_TRANSITION[duration]:-0.8}" \
        --transition-fps "${WALLPAPERS_TRANSITION[fps]:-60}" \
        --transition-step "${WALLPAPERS_TRANSITION[step]:-90}" \
        --transition-bezier "${WALLPAPERS_TRANSITION[bezier]:-.54,0,.34,.99}" \
        "$image"
}

sync_lock_state() {
    local image="$1" dir="${WALLPAPERS_CAELESTIA_STATE:-}"

    [[ ${WALLPAPERS_SYNC_CAELESTIA:-0} == 1 && -n $dir && -n $image ]] || return 0

    mkdir -p "$dir"
    if [[ "$(cat "$dir/path.txt" 2>/dev/null || true)" != "$image" ]]; then
        printf '%s' "$image" >"$dir/path.txt"
        ln -sfn "$image" "$dir/current"
    fi
}

apply_all() {
    ensure_daemon || return 1

    local list
    if ! list="$(monitors)"; then
        log "could not query Hyprland, is a session running?"
        return 1
    fi

    local -A shown=()
    local name path
    while IFS=$'\t' read -r name path; do
        [[ -n $name ]] && shown["$name"]="$path"
    done < <(displayed_images)

    local monitor workspace focused image focused_image=''
    while IFS=$'\t' read -r monitor workspace focused; do
        [[ -n $monitor ]] || continue

        image="$(resolve_image "$monitor" "$workspace")"
        if [[ -z $image ]]; then
            log "no wallpaper configured for ${monitor}:${workspace} and no default set"
            continue
        fi

        if [[ ${shown[$monitor]:-} != "$image" ]]; then
            set_wallpaper "$monitor" "$image"
        fi

        if [[ $focused == true ]]; then
            focused_image="$image"
        fi
    done <<<"$list"

    sync_lock_state "$focused_image"
}

status() {
    printf 'default       %s\n' "${WALLPAPERS_DEFAULT:-<none>}"
    printf 'resize        %s\n' "${WALLPAPERS_RESIZE:-crop}"
    printf 'transition    %s, %ss, %s fps, step %s, bezier %s\n' \
        "${WALLPAPERS_TRANSITION[type]:-fade}" \
        "${WALLPAPERS_TRANSITION[duration]:-0.8}" \
        "${WALLPAPERS_TRANSITION[fps]:-60}" \
        "${WALLPAPERS_TRANSITION[step]:-90}" \
        "${WALLPAPERS_TRANSITION[bezier]:-.54,0,.34,.99}"
    printf 'lock screen   %s\n' \
        "$([[ ${WALLPAPERS_SYNC_CAELESTIA:-0} == 1 ]] && printf 'follows the focused monitor' || printf 'untouched')"
    printf '\nmapping (%s entries):\n' "${#WALLPAPERS_MAP[@]}"

    local key
    for key in $(printf '%s\n' "${!WALLPAPERS_MAP[@]}" | sort); do
        printf '  %-14s %s\n' "$key" "${WALLPAPERS_MAP[$key]}"
    done
}

case "${1:-}" in
    apply)
        apply_all
        ;;
    resolve)
        if [[ $# -ne 3 ]]; then
            printf '%s\n' "$USAGE" >&2
            exit 2
        fi
        resolve_image "$2" "$3"
        printf '\n'
        ;;
    status)
        status
        ;;
    *)
        printf '%s\n' "$USAGE" >&2
        exit 2
        ;;
esac
