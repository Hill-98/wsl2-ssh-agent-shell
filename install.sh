#!/bin/bash

cd "$(dirname "$0")" || exit 1

SERVICE_PATH=$HOME/.config/systemd/user/wsl2-ssh-agent-shell.service

sed "s|<exec>|$PWD/wsl2-ssh-agent.sh|" wsl2-ssh-agent.service.in | install -D -m 644 -v /dev/stdin "$SERVICE_PATH"

echo
echo -e "\033[1m${SERVICE_PATH}e:\033[0m"
echo 
cat "$SERVICE_PATH"

systemctl --user daemon-reload
