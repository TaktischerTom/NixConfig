#!/usr/bin/env bash
# Bring up the "vpn" network namespace with a WireGuard tunnel inside it.
#
# Usage: vpn-netns-up <config-name>
set -euo pipefail

NS="vpn"
IFACE="wg0"
CONFIG_DIR="/etc/wireguard"
STATE_DIR="/run/vpn-netns"

if [ "$(id -u)" -ne 0 ]; then
    echo "vpn-netns-up must run as root" >&2
    exit 1
fi

config="${1:?usage: vpn-netns-up <config-name>}"
conf="$CONFIG_DIR/$config.conf"

if [ ! -f "$conf" ]; then
    echo "Config '$config' not found at $conf" >&2
    exit 1
fi

# --- parse the WireGuard config --------------------------
# Grab the [Interface] Address / DNS and the [Peer] section
get_key() {
    sed -nE "s/^[[:space:]]*$1[[:space:]]*=[[:space:]]*(.*[^[:space:]])[[:space:]]*$/\1/p" "$conf" | head -n1
}

address="$(get_key Address)"
dns="$(get_key DNS)"
mtu="$(get_key MTU)"
mtu="${mtu:-1420}"

if [ -z "$address" ]; then
    echo "No 'Address' found in $conf" >&2
    exit 1
fi

# --- (re)create the namespace -------------------------
if ip netns list | grep -qw "$NS"; then
    ip -n "$NS" link del "$IFACE" 2>/dev/null || true
    ip netns del "$NS" 2>/dev/null || true
fi
ip link del "$IFACE" 2>/dev/null || true

ip netns add "$NS"
ip -n "$NS" link set lo up

ipv6_on=true
if ! echo "$address" | grep -q ':'; then
    ipv6_on=false
    ip netns exec "$NS" sysctl -qw net.ipv6.conf.all.disable_ipv6=1
    ip netns exec "$NS" sysctl -qw net.ipv6.conf.default.disable_ipv6=1
fi

ip link add "$IFACE" type wireguard
ip link set "$IFACE" netns "$NS"

stripped="$(umask 077; mktemp)"
trap 'rm -f "$stripped"' EXIT
wg-quick strip "$conf" > "$stripped"
ip netns exec "$NS" wg setconf "$IFACE" "$stripped"

IFS=',' read -ra addrs <<< "$address"
for a in "${addrs[@]}"; do
    a="$(echo "$a" | tr -d '[:space:]')"
    [ -z "$a" ] && continue
    ip -n "$NS" addr add "$a" dev "$IFACE"
done
ip -n "$NS" link set "$IFACE" mtu "$mtu"
ip -n "$NS" link set "$IFACE" up

ip -n "$NS" route add default dev "$IFACE"
if echo "$address" | grep -q ':'; then
    ip -n "$NS" -6 route add default dev "$IFACE" 2>/dev/null || true
fi

ip netns exec "$NS" iptables -t mangle -A POSTROUTING -o "$IFACE" \
    -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu 2>/dev/null || true

v4_dns=""
v6_dns=""
if [ -n "$dns" ]; then
    IFS=',' read -ra servers <<< "$dns"
    for s in "${servers[@]}"; do
        s="$(echo "$s" | tr -d '[:space:]')"
        [ -z "$s" ] && continue
        if echo "$s" | grep -q ':'; then
            [ -n "$v6_dns" ] || v6_dns="$s"
        else
            [ -n "$v4_dns" ] || v4_dns="$s"
        fi
    done
fi
v4_dns="${v4_dns:-1.1.1.1}"

ip netns exec "$NS" iptables -t nat -A OUTPUT -p udp --dport 53 \
    -j DNAT --to-destination "$v4_dns" 2>/dev/null || true
ip netns exec "$NS" iptables -t nat -A OUTPUT -p tcp --dport 53 \
    -j DNAT --to-destination "$v4_dns" 2>/dev/null || true

if $ipv6_on && [ -n "$v6_dns" ]; then
    ip netns exec "$NS" ip6tables -t nat -A OUTPUT -p udp --dport 53 \
        -j DNAT --to-destination "$v6_dns" 2>/dev/null || true
    ip netns exec "$NS" ip6tables -t nat -A OUTPUT -p tcp --dport 53 \
        -j DNAT --to-destination "$v6_dns" 2>/dev/null || true
fi

mkdir -p "/etc/netns/$NS"
if [ -n "$dns" ]; then
    : > "/etc/netns/$NS/resolv.conf"
    IFS=',' read -ra servers <<< "$dns"
    for s in "${servers[@]}"; do
        s="$(echo "$s" | tr -d '[:space:]')"
        [ -z "$s" ] && continue
        echo "nameserver $s" >> "/etc/netns/$NS/resolv.conf"
    done
else
    echo "nameserver 1.1.1.1" > "/etc/netns/$NS/resolv.conf"
fi

# --- record which config is active -----------------
mkdir -p "$STATE_DIR"
echo "$config" > "$STATE_DIR/active"

echo "VPN namespace '$NS' up using config '$config'"
