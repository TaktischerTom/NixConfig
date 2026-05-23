#!/usr/bin/env bash
# Opens a single firefox window containing the WaniKani and Bunpro tabs
# inside the `special:wanikani` Hyprland workspace, but only if no firefox
# window is already present in that workspace.

set -u

WS="special:wanikani"
PROFILE="wanikani"
URL1="https://www.wanikani.com/"
URL2="https://bunpro.jp/dashboard"

for _ in $(seq 1 30); do
    if hyprctl version >/dev/null 2>&1; then
        break
    fi
    sleep 0.1
done

clients_json() {
    hyprctl clients -j 2>/dev/null || echo '[]'
}

already_present="$(clients_json | jq --arg ws "$WS" '
    [ .[]
      | select(.workspace.name == $ws)
      | select((.class // "") | test("firefox"; "i"))
    ] | length
')"
if [ "${already_present:-0}" -gt 0 ]; then
    exit 0
fi

PROFILE_INI="${HOME}/.mozilla/firefox/profiles.ini"
if ! grep -qx "Name=${PROFILE}" "$PROFILE_INI" 2>/dev/null; then
    firefox --no-remote -CreateProfile "$PROFILE" >/dev/null 2>&1 || true
fi

before="$(clients_json | jq -r '
    .[] | select((.class // "") | test("firefox"; "i")) | .address
')"

setsid firefox --no-remote -P "$PROFILE" "$URL1" "$URL2" >/dev/null 2>&1 &
disown

new_addr=""
for _ in $(seq 1 300); do
    sleep 0.1
    new_addr="$(clients_json | jq -r --arg before "$before" '
        ($before | split("\n") | map(select(length > 0))) as $known
        | .[]
        | select((.class // "") | test("firefox"; "i"))
        | select(.address as $a | ($known | index($a)) | not)
        | select(((.title // "") + " " + (.initialTitle // ""))
                 | test("wanikani|bunpro"; "i"))
        | .address
    ' | head -n1)"
    if [ -n "$new_addr" ]; then
        break
    fi
done

if [ -n "$new_addr" ]; then
    hyprctl dispatch movetoworkspacesilent "${WS},address:${new_addr}" >/dev/null
fi
