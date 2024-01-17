#!/bin/bash

ROOT_DIR=$(dirname "$(readlink -f "$0")")

cd "$ROOT_DIR" || exit 1

. common.sh

systemctl --user disable --now wsl2-ssh-agent.service
systemctl --user daemon-reload

rm -v "$SERVICE_PATH"
rm -v "$KNOWN_HOSTS_FILE_WSL" "$SSH_KEY_FILE_WSL"
rm -r -v "$DATA_DIR"
