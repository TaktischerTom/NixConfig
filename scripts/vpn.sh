#!/usr/bin/env bash
set -euo pipefail

CONFIG_DIR="/etc/wireguard"
DEFAULT_CONFIG="protonvpn-nl"
NS="vpn"
STATE_DIR="/run/vpn-netns"

usage() {
    cat <<EOF
Usage: vpn <command> [config]

Runs the VPN inside a dedicated network namespace ('$NS'). Apps launched with
'vpn-run <app>' (or the qbittorrent launcher) can ONLY use the tunnel and have
no fallback to the default network. Everything else (e.g. Firefox) is unaffected
and never touches the VPN.

Commands:
  on  [config]    Bring up the VPN namespace (default: $DEFAULT_CONFIG)
  off             Tear down the VPN namespace
  toggle [config] Toggle on/off (default if no command given)
  status          Show the active tunnel / namespace state
  list            List available configs in $CONFIG_DIR

Examples:
  vpn on
  vpn on protonvpn-us
  vpn-run qbittorrent
  vpn off
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
    ip netns list 2>/dev/null | grep -qw "$NS"
}

active_config() {
    sudo cat "$STATE_DIR/active" 2>/dev/null || true
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
        if is_up; then
            echo "VPN namespace already up (config: $(active_config))"
            exit 0
        fi
        sudo vpn-netns-up "$config"
        ;;
    off|down|stop)
        if ! is_up; then
            echo "VPN namespace not running"
            exit 0
        fi
        sudo vpn-netns-down
        ;;
    status|st)
        if ! is_up; then
            echo "VPN namespace '$NS' is down"
            exit 0
        fi
        echo "VPN namespace '$NS' is up (config: $(active_config))"
        echo
        sudo ip netns exec "$NS" wg show 2>/dev/null || true
        ;;
    list|ls)
        list_configs
        ;;
    toggle)
        if is_up; then
            sudo vpn-netns-down
        else
            ensure_config_exists "$config"
            sudo vpn-netns-up "$config"
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
