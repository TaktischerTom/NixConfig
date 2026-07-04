#!/usr/bin/env bash
# Tear down the "vpn" network namespace created by vpn-netns-up.
set -euo pipefail

NS="vpn"
IFACE="wg0"
STATE_DIR="/run/vpn-netns"

if [ "$(id -u)" -ne 0 ]; then
    echo "vpn-netns-down must run as root" >&2
    exit 1
fi

if ip netns list | grep -qw "$NS"; then
    ip -n "$NS" link del "$IFACE" 2>/dev/null || true
    ip netns del "$NS" 2>/dev/null || true
fi
# Remove any interface that failed to move into the namespace.
ip link del "$IFACE" 2>/dev/null || true

rm -f "/etc/netns/$NS/resolv.conf"
rmdir "/etc/netns/$NS" 2>/dev/null || true
rm -f "$STATE_DIR/active"

echo "VPN namespace '$NS' down"
