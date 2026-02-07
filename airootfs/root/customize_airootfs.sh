#!/bin/bash
set -e

# --- System Configuration ---
# Set Timezone
ln -sf /usr/share/zoneinfo/UTC /etc/localtime

# Enable Networking
systemctl enable NetworkManager

# Enable Gaming Services
systemctl enable gamemoded

# --- AI Integration: OpenClaw / Moltbot ---
echo "Installing OpenClaw Agent..."

# Note: In a real airootfs, network might not be available during this chroot phase 
# unless specifically enabled. If not, this must be done on first boot.
# For ISO, best practice is to download in build script and copy to airootfs.
# Here we assume a post-install hook or just pre-configure directory.

mkdir -p /opt/GravityOS/Agents
# Usually we'd copy the cloned repo from the host during build.sh, 
# but for now we'll create the skeleton.

# Create a systemd service to launch the agent or onboarding on login
cat <<EOF > /etc/systemd/system/openclaw.service
[Unit]
Description=OpenClaw AI Agent
After=network.target

[Service]
ExecStart=/usr/bin/node /opt/GravityOS/Agents/OpenClaw/index.js
Restart=always
User=root
Environment=NODE_ENV=production

[Install]
WantedBy=multi-user.target
EOF

# --- Vibe Aesthetics (Hyprland Config) ---
# Create default user 'gravity' with password 'gravity'
useradd -m -G wheel -s /bin/zsh gravity
echo "gravity:gravity" | chpasswd
echo "root:gravity" | chpasswd

# Setup ZSH
# (Usually we'd pre-install Oh-My-Zsh here but it requires heavy git cloning)

echo "GravityOS Customization Applied."
