__SSH_AUTH_SOCK___=$1

ln -f -s -v "$SSH_AUTH_SOCK" "$__SSH_AUTH_SOCK___"

_exit() {
    if [[ -L "$__SSH_AUTH_SOCK___" ]]; then
        rm -v "$__SSH_AUTH_SOCK___"
    fi
    exit 0
}

trap _exit SIGINT SIGTERM EXIT

sleep 60

while [[ $(pgrep --count Relay) -gt 1 ]]; do
    sleep 600
done
