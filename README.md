# wsl2-ssh-agent-shell

Share Windows ssh-agent to WSL2 using SSH agent forwarding

## Usage

0. Install OpenSSH Server: `sudo apt install openssh-server`

1. Clone this repository to WSL: `git clone https://github.com/Hill-98/wsl2-ssh-agent-shell.git ~/wsl2-ssh-agent-shell`

2. Run the installation script: `bash ~/wsl2-ssh-agent-shell/install.sh`

3. Enable and start wsl2-ssh-agent-shell systemd service: `systemctl --user enable --now wsl2-ssh-agent-shell.service`

4. Add this line to your `.bashrc` or `.zshrc`: `export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/wsl2-ssh-agent-shell.sock`

5. Done. Reopen the WSL Shell and enjoy!

## Known issues

* WSL auto-shutdown will not work because the SSH session is considered an active terminal by it.
