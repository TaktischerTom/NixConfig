#!/usr/bin/env bash
set -euo pipefail

CONFIG_DIR="/etc/wireguard"
DEFAULT_CONFIG="protonvpn-nl"

usage() {
    cat <<EOF
Usage: vpn <command> [config]

Commands:
  on  [config]    Connect (default: $DEFAULT_CONFIG)
  off [config]    Disconnect
  toggle [config] Toggle on/off (default if no command given)
  status          Show active WireGuard tunnels
  list            List available configs in $CONFIG_DIR

Examples:
  vpn on
  vpn off
  vpn on us-free-1
  vpn status
EOF
}

list_configs() {
    if [ ! -d "$CONFIG_DIR" ]; then
        echo "No config dir at $CONFIG_DIR" >&2
        return 1
    fi
    local found
    found=$(find "$CONFIG_DIR" -maxdepth 1 -name '*.conf' -type f -printf '%f\n' 2>/dev/null | sed 's/\.conf$//' | sort)
    if [ -z "$found" ]; then
        echo "No .conf files found in $CONFIG_DIR" >&2
        return 1
    fi
    echo "$found"
}

is_up() {
    sudo wg show "$1" >/dev/null 2>&1
}

ensure_config_exists() {
    if [ ! -f "$CONFIG_DIR/$1.conf" ]; then
        echo "Config '$1' not found at $CONFIG_DIR/$1.conf" >&2
        echo "Available configs:" >&2
        list_configs >&2 || true
        exit 1
    fi
}

cmd="${1:-toggle}"
config="${2:-$DEFAULT_CONFIG}"

case "$cmd" in
    on|up|start)
        ensure_config_exists "$config"
        if is_up "$config"; then
            echo "VPN '$config' already up"
            exit 0
        fi
        sudo wg-quick up "$config"
        ;;
    off|down|stop)
        if ! is_up "$config"; then
            echo "VPN '$config' not running"
            exit 0
        fi
        sudo wg-quick down "$config"
        ;;
    status|st)
        out=$(sudo wg show 2>/dev/null || true)
        if [ -z "$out" ]; then
            echo "No active WireGuard tunnels"
        else
            echo "$out"
        fi
        ;;
    list|ls)
        list_configs
        ;;
    toggle)
        if is_up "$config"; then
            sudo wg-quick down "$config"
        else
            ensure_config_exists "$config"
            sudo wg-quick up "$config"
        fi
        ;;
    -h|--help|help)
        usage
        ;;
    *)
        usage >&2
        exit 1
        ;;
esac
