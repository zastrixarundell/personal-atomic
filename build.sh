#!/bin/bash

set -ouex pipefail

if [ $UNSTABLE_COMPONENTS == "true" ]; then
    /bin/bash ./build.d/latest_kernel.sh
fi

/bin/bash /tmp/build.d/sources.sh

/bin/bash /tmp/build.d/update_ostree.sh

systemctl enable podman.socket

# Wanted background services
systemctl enable tailscaled.service
systemctl enable sunshine-workaround.service
systemctl enable sshd.service
systemctl enable avahi-daemon.service

# Enable auto-system updates
systemctl enable rpm-ostreed-automatic.timer
systemctl enable flatpak-system-update.timer
systemctl --global enable flatpak-user-update.timer
systemctl --global enable container-update.timer

# Decrease the boot-time
systemctl disable NetworkManager-wait-online.service

# Setup for PipeWire so there's less audio stuttering with EasyEffects
mkdir -p /etc/pipewire

cp /usr/share/pipewire/pipewire.conf /etc/pipewire/

sed -i 's/#default.clock.quantum[[:space:]]*= 1024/default.clock.quantum       = 512/g'     /etc/pipewire/pipewire.conf
sed -i 's/#default.clock.min-quantum[[:space:]]*= 32/default.clock.min-quantum   = 512/g'   /etc/pipewire/pipewire.conf
sed -i 's/#default.clock.max-quantum[[:space:]]*= 2048/default.clock.max-quantum   = 512/g' /etc/pipewire/pipewire.conf

# Corectrl without password
groupadd corectrl
