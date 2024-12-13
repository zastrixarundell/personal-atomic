#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

if [ $LATEST_KERNEL == "true" ]; then
    /bin/bash ./build.d/latest_kernel.sh
fi

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# Setting custom repositories

/bin/bash /tmp/build.d/sources.sh

/bin/bash /tmp/build.d/update_ostree.sh

#### Example for enabling a System Unit File
systemctl enable podman.socket

systemctl enable tailscaled.service

systemctl enable sunshine-workaround.service

systemctl enable sshd.service

# Decrease the boot-time
systemctl disable NetworkManager-wait-online.service

# Enable auto-system updates
systemctl enable rpm-ostreed-automatic.timer

# Enable mDNS
systemctl enable avahi-daemon.service

# Setup for PipeWire so there's no audio stuttering with EasyEffects

mkdir -p /etc/pipewire

cp /usr/share/pipewire/pipewire.conf /etc/pipewire/

sed -i 's/#default.clock.quantum[[:space:]]*= 1024/default.clock.quantum       = 512/g'     /etc/pipewire/pipewire.conf
sed -i 's/#default.clock.min-quantum[[:space:]]*= 32/default.clock.min-quantum   = 512/g'   /etc/pipewire/pipewire.conf
sed -i 's/#default.clock.max-quantum[[:space:]]*= 2048/default.clock.max-quantum   = 512/g' /etc/pipewire/pipewire.conf

# Corectrl without password

groupadd corectrl

# Default custom services

systemctl --global enable flatpak-user-update.timer
systemctl --global enable container-update.timer
systemctl enable flatpak-system-update.timer