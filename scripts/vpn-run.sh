#!/usr/bin/env bash
# Launch a command inside the "vpn" network namespace
#
# Usage: vpn-run <command> [args...]
set -euo pipefail

NS="vpn"

if [ "$#" -lt 1 ]; then
    echo "Usage: vpn-run <command> [args...]" >&2
    exit 1
fi

if ! ip netns list 2>/dev/null | grep -qw "$NS"; then
    echo "VPN namespace '$NS' is not active." >&2
    echo "Start it first with:  vpn on" >&2
    command -v notify-send >/dev/null 2>&1 && \
        notify-send "VPN not active" "Run 'vpn on' before launching VPN-only apps." || true
    exit 1
fi

run_user="${USER:-$(id -un)}"

env_vars=""
for v in DISPLAY WAYLAND_DISPLAY XDG_RUNTIME_DIR XAUTHORITY HOME \
         DBUS_SESSION_BUS_ADDRESS PATH QT_QPA_PLATFORM GDK_BACKEND \
         XDG_DATA_DIRS XDG_CONFIG_HOME LANG; do
    if [ -n "${!v:-}" ]; then
        env_vars+="$v=${!v} "
    fi
done

exec sudo ip netns exec "$NS" \
    runuser -u "$run_user" -- env $env_vars "$@"
