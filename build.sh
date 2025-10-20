#!/bin/bash

set -ouex pipefail

if [ $UNSTABLE_COMPONENTS == "true" ]; then
    /bin/bash /tmp/build.d/latest_kernel.sh
fi

if [ $LAPTOP == "true" ]; then
    /bin/bash /tmp/build.d/laptop.sh
fi

/bin/bash /tmp/build.d/sources.sh

# Testing if asdf can be skipped, if
# brew sets asdf properly then there's no need to
# install asdf into the image.
# /bin/bash /tmp/build.d/asdf.sh

/bin/bash /tmp/build.d/update_ostree.sh

systemctl enable podman.socket

# Wanted background services
systemctl enable tailscaled.service
systemctl enable sunshine-workaround.service
systemctl enable sshd.service
systemctl enable avahi-daemon.service
systemctl enable docker

# Enable auto-system updates
systemctl enable rpm-ostreed-automatic.service
systemctl enable rpm-ostreed-automatic.timer
systemctl enable flatpak-system-update.timer
systemctl --global enable flatpak-user-update.timer
systemctl --global enable container-update.timer

# Decrease the boot-time
systemctl disable NetworkManager-wait-online.service

# Setup virt-manager for VMs
systemctl enable libvirtd

# Setup for PipeWire so there's less audio stuttering with EasyEffects
mkdir -p /etc/pipewire

cp /usr/share/pipewire/pipewire.conf /etc/pipewire/

sed -i 's/#default.clock.quantum[[:space:]]*= 1024/default.clock.quantum       = 512/g'     /etc/pipewire/pipewire.conf
sed -i 's/#default.clock.min-quantum[[:space:]]*= 32/default.clock.min-quantum   = 512/g'   /etc/pipewire/pipewire.conf
sed -i 's/#default.clock.max-quantum[[:space:]]*= 2048/default.clock.max-quantum   = 512/g' /etc/pipewire/pipewire.conf

# Use fish as the default shell
sed -i 's@/bin/bash@/bin/fish@g' /etc/default/useradd

chsh -s /bin/fish root

# Corectrl without password
groupadd corectrl

# Ydotool for control without extra args
groupadd ydotool

# Update tldr list of commands
tldr --update

# Create syslink for Sunshine and a fedora bug
sudo ln -s /usr/lib64/libminiupnpc.so.2.3.0 /usr/lib64/libminiupnpc.so.17

# Create group for docker, because ostree has a bug, see: https://docs.fedoraproject.org/en-US/fedora-silverblue/troubleshooting/#_unable_to_add_user_to_group
# sudo sh -c "grep -E '^docker:' /usr/lib/group >> /etc/group"
