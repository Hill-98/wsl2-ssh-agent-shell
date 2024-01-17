#!/bin/bash

ROOT_DIR=$(dirname "$(readlink -f "$0")")

cd "$ROOT_DIR" || exit 1

. common.sh

sed "s|<exec>|$PWD/wsl2-ssh-agent.sh|" wsl2-ssh-agent.service.in | install -D -m 644 -v /dev/stdin "$SERVICE_PATH"

echo
echo -e "\033[1m${SERVICE_PATH}:\033[0m"
echo 
cat "$SERVICE_PATH"

systemctl --user daemon-reload
