#!/bin/bash

. /etc/os-release

SSHD_PORT=${SSHD_PORT:-34672}

DATA_DIR=${XDG_DATA_HOME:-$HOME/.local/share}/wsl2-ssh-agent-shell

# shellcheck disable=SC1003
DRIVER_C=$(printf "%s" "$(grep 'C:\\' /proc/mounts | cut -d " " -f 2)")
PowerShell="$DRIVER_C/Windows/System32/WindowsPowerShell/v1.0/powershell.exe"
SSH="$DRIVER_C/Windows/System32/OpenSSH/ssh.exe"

USERPROFILE=$($PowerShell -NoLogo -NoProfile -NonInteractive -Command '[System.Environment]::GetEnvironmentVariable("USERPROFILE")' | sed $'s/\r//')
KNOWN_HOSTS_FILE="$USERPROFILE\\AppData\\Local\\KnownHosts.$ID.wsl2-ssh-agent-shell"
KNOWN_HOSTS_FILE_WSL="$(wslpath -u "$KNOWN_HOSTS_FILE")"
SSH_KEY_FILE="$USERPROFILE\\.ssh\\wsl2-ssh-agent-shell.$ID.key"
SSH_KEY_FILE_WSL="$(wslpath -u "$SSH_KEY_FILE")"

SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/wsl2-ssh-agent-shell.sock"

_exit() {
    # shellcheck disable=SC2046
    kill $(jobs -pr)
}

trap _exit SIGINT SIGTERM EXIT

if [[ ! -d $DATA_DIR ]]; then
    mkdir -p "$DATA_DIR"
    chmod 700 "$DATA_DIR"
fi
cd "$DATA_DIR" || exit 1

if [[ ! -f key ]]; then
    ssh-keygen -f host_key -N "" -q
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
PidFile "$XDG_RUNTIME_DIR/wsl2-ssh-agent-shell.pid"
EOF

$(which sshd) -4 -D -f sshd.conf -p "$SSHD_PORT" &

rm "$KNOWN_HOSTS_FILE_WSL"

# shellcheck disable=SC2016
$SSH -i "$SSH_KEY_FILE" -l "$USER" -o ForwardAgent=yes -o StrictHostKeyChecking=no -o "UserKnownHostsFile=$KNOWN_HOSTS_FILE" -T 127.0.0.1 -p "$SSHD_PORT" "ln -sf \"\$SSH_AUTH_SOCK\" '$SSH_AUTH_SOCK'; while true; do sleep 60; done"
