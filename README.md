# wsl2-ssh-agent-shell

Share Windows ssh-agent to WSL2 using SSH agent forwarding

## Usage

0. Install OpenSSH server on your wsl distro: `sudo apt install openssh-server`

1. Clone this repository to WSL: `git clone https://github.com/Hill-98/wsl2-ssh-agent-shell.git ~/wsl2-ssh-agent-shell`

2. Run the installation script: `bash ~/wsl2-ssh-agent-shell/install.sh`

3. Enable and start wsl2-ssh-agent-shell systemd service: `systemctl --user enable --now wsl2-ssh-agent-shell.service`

4. Add this line to your `.bashrc` or `.zshrc`: `systemctl --user start wsl2-ssh-agent-shell.service; export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/wsl2-ssh-agent-shell.sock`

5. Done. Reopen the WSL Shell and enjoy!

## Notes

OpenSSH 8.9 extends ssh-agent so that it is no longer compatible with older versions of OpenSSH ssh-agent, but the version of OpenSSH built into Windows is currently only 8.6, so it is not compatible with OpenSSH on some modern Linux distributions.

If you want to use this project on a Linux distribution with OpenSSH 8.9+, you will need to manually update Windows OpenSSH and use the new ssh-agent.exe, or use another ssh-agent implementation (such as the 1Password client's ssh-agent ).

Since WSL treats the SSH session as an active terminal, WSL doesn't auto shutdown, I used a clumsy method to detect if there are currently other active terminals, and if not, SSH agent forwarding is turned off, allow WSL to auto shutdown.
