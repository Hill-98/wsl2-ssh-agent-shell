#!/bin/bash
__SSH_AUTH_SOCK__=$1
__RELAY_MIN_COUNT__=$2

echo "__SSH_AUTH_SOCK__: $__SSH_AUTH_SOCK__"
echo "__RELAY_MIN_COUNT__: $__RELAY_MIN_COUNT__"

ln -f -s -v "$SSH_AUTH_SOCK" "$__SSH_AUTH_SOCK__"

_exit() {
    if [[ -L "$__SSH_AUTH_SOCK__" ]]; then
        rm -v "$__SSH_AUTH_SOCK__"
    fi
    exit 0
}

relay_count() {
    local count
    count=$(pgrep --count Relay)
    echo "[$(date --iso-8601=seconds)] Relay count: $count" >&2
    echo "$count"
}

trap _exit SIGINT SIGTERM EXIT

while [[ $(relay_count) -gt $__RELAY_MIN_COUNT__ ]]; do
    sleep 600
done
