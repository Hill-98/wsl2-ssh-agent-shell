#!/bin/bash

SSHD_PORT=${SSHD_PORT:-34672}
RELAY_MIN_COUNT=${RELAY_MIN_COUNT:-0}
ROOT_DIR=$(dirname "$(readlink -f "$0")")

cd "$ROOT_DIR" || exit 1

. common.sh

SSH="ssh.exe"

_exit() {
    # shellcheck disable=SC2046
    kill $(jobs -pr)
    exit 0
}

trap _exit SIGINT SIGTERM EXIT

if [[ -f "$DRIVER_C/Windows/System32/OpenSSH/ssh.exe" ]]; then
    SSH="$DRIVER_C/Windows/System32/OpenSSH/ssh.exe"
fi

if [[ -f "$DRIVER_C/Program Files/OpenSSH/ssh.exe" ]]; then
    SSH="$DRIVER_C/Program Files/OpenSSH/ssh.exe"
fi

if [[ ! -d $DATA_DIR ]]; then
    mkdir -p "$DATA_DIR"
    chmod 700 "$DATA_DIR"
fi
cd "$DATA_DIR" || exit 1

if [[ ! -f host_key ]]; then
    ssh-keygen -f host_key -N "" -q
fi

if [[ ! -f key ]]; then
    ssh-keygen -f key -N "" -q
fi

if [[ ! -f "$SSH_KEY_FILE_WSL" ]]; then
    cp -f key "$SSH_KEY_FILE_WSL"
fi

cat > sshd.conf <<EOF
AllowAgentForwarding yes
AllowUsers $USER
AuthorizedKeysFile "$DATA_DIR/key.pub"
HostKey "$DATA_DIR/host_key"
PasswordAuthentication no
PidFile "${XDG_RUNTIME_DIR:-$DATA_DIR}/wsl2-ssh-agent-shell.pid"
EOF

"$(command -v sshd)" -4 -D -f sshd.conf -p "$SSHD_PORT" &

rm "$KNOWN_HOSTS_FILE_WSL"

"$SSH" -A -i "$SSH_KEY_FILE" -l "$USER" \
    -o StrictHostKeyChecking=no -o "UserKnownHostsFile=$KNOWN_HOSTS_FILE" \
    -p "$SSHD_PORT" -t 127.0.0.1 \
    "$ROOT_DIR/loop.sh '$XDG_RUNTIME_DIR/wsl2-ssh-agent-shell.sock' '$RELAY_MIN_COUNT'"
