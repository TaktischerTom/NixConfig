#!/usr/bin/env bash
set -euo pipefail

# The predefined message
SUMMARY="Royal decree"
BODY="Your highness, the shell has spoken."

# Send notification using Quickshell
quickshell -e "
import Quickshell.Services.Notifications 1.0

Notification {
    summary: \"$SUMMARY\"
    body: \"$BODY\"
}
"