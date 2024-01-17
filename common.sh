#!/bin/false
. /etc/os-release

SERVICE_PATH=$HOME/.config/systemd/user/wsl2-ssh-agent-shell.service

DATA_DIR=${XDG_DATA_HOME:-$HOME/.local/share}/wsl2-ssh-agent-shell

# shellcheck disable=SC1003
DRIVER_C=$(printf "%s" "$(grep 'C:\\' /proc/mounts | cut -d " " -f 2)")
PowerShell="$DRIVER_C/Windows/System32/WindowsPowerShell/v1.0/powershell.exe"

USERPROFILE=$($PowerShell -NoLogo -NoProfile -NonInteractive -Command '[System.Environment]::GetEnvironmentVariable("USERPROFILE")' | sed $'s/\r//')
KNOWN_HOSTS_FILE="$USERPROFILE\\AppData\\Local\\KnownHosts.$ID.wsl2-ssh-agent-shell"
KNOWN_HOSTS_FILE_WSL="$(wslpath -u "$KNOWN_HOSTS_FILE")"
SSH_KEY_FILE="$USERPROFILE\\.ssh\\wsl2-ssh-agent-shell.$ID.key"
SSH_KEY_FILE_WSL="$(wslpath -u "$SSH_KEY_FILE")"
