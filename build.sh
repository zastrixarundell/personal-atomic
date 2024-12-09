#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

if [ $LATEST_KERNEL == "true" ]; then
    # Install the latest version of the kernel
    CLEAN_KERNEL_VERSION=$(curl -L -s https://packages.fedoraproject.org/pkgs/kernel/kernel/fedora-rawhide.html | grep '<title>' | sed -n 's/.*kernel-\([^ ]*\).*/\1/p')

    KERNEL_VERSION=$(echo $CLEAN_KERNEL_VERSION | sed -n 's/\([0-9]\+\.[0-9]\+\.[0-9]\+\).*/\1/p')
    
    KERNEL_VERSION_NUMBER=$(echo $CLEAN_KERNEL_VERSION | sed "s/$KERNEL_VERSION-//")
    
    curl -Lo /tmp/kernel-$KERNEL_VERSION-$KERNEL_VERSION_NUMBER.x86_64.rpm https://kojipkgs.fedoraproject.org/packages/kernel/$KERNEL_VERSION/$KERNEL_VERSION_NUMBER/x86_64/kernel-$KERNEL_VERSION-$KERNEL_VERSION_NUMBER.x86_64.rpm
    curl -Lo /tmp/kernel-modules-$KERNEL_VERSION-$KERNEL_VERSION_NUMBER.x86_64.rpm https://kojipkgs.fedoraproject.org/packages/kernel/$KERNEL_VERSION/$KERNEL_VERSION_NUMBER/x86_64/kernel-modules-$KERNEL_VERSION-$KERNEL_VERSION_NUMBER.x86_64.rpm
    curl -Lo /tmp/kernel-modules-extra-$KERNEL_VERSION-$KERNEL_VERSION_NUMBER.x86_64.rpm https://kojipkgs.fedoraproject.org/packages/kernel/$KERNEL_VERSION/$KERNEL_VERSION_NUMBER/x86_64/kernel-modules-extra-$KERNEL_VERSION-$KERNEL_VERSION_NUMBER.x86_64.rpm
    curl -Lo /tmp/kernel-core-$KERNEL_VERSION-$KERNEL_VERSION_NUMBER.x86_64.rpm https://kojipkgs.fedoraproject.org/packages/kernel/$KERNEL_VERSION/$KERNEL_VERSION_NUMBER/x86_64/kernel-core-$KERNEL_VERSION-$KERNEL_VERSION_NUMBER.x86_64.rpm
    curl -Lo /tmp/kernel-modules-core-$KERNEL_VERSION-$KERNEL_VERSION_NUMBER.x86_64.rpm https://kojipkgs.fedoraproject.org/packages/kernel/$KERNEL_VERSION/$KERNEL_VERSION_NUMBER/x86_64/kernel-modules-core-$KERNEL_VERSION-$KERNEL_VERSION_NUMBER.x86_64.rpm

    rpm-ostree override replace \
    /tmp/kernel-{,modules-,modules-extra-,modules-core-,core-}$KERNEL_VERSION-$KERNEL_VERSION_NUMBER.x86_64.rpm
fi

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# Setting custom repositories

curl -Lo /etc/yum.repos.d/_copr_matte-schwartz-sunshine.repo https://copr.fedorainfracloud.org/coprs/matte-schwartz/sunshine/repo/fedora-"${RELEASE}"/matte-schwartz-sunshine-fedora-"${RELEASE}".repo

curl -Lo /etc/yum.repos.d/tailscale.repo https://pkgs.tailscale.com/stable/fedora/tailscale.repo

sed -i 's@gpgcheck=1@gpgcheck=0@g' /etc/yum.repos.d/tailscale.repo

# Coding:
#   - code
#   - inotify-tools
#   - android-tools
#   - podman-compose

# System information:
#   - ncdu
#   - fastfetch
#   - btop
#   - rocm-smi (for btop gpu W)

# System control:
#   - corectrl
#   - goverlay
#   - sunshine
#   - qpwgraph
#   - tailscale

# Windows:
#   - WoeUSB

# Audio work:
#   - realtime-setup

rpm-ostree install \
    code \
    inotify-tools \
    android-tools \
    podman-compose \
    ncdu \
    fastfetch \
    btop \
    rocm-smi \
    corectrl \
    goverlay \
    sunshine \
    qpwgraph \
    tailscale \
    WoeUSB \
    realtime-setup \
    openrgb-udev-rules \
    htop \
    zstd

rpm-ostree uninstall firefox firefox-langpacks

# Rustdesk has no repo, but it does provide github binaries

rustdesk_url=$(curl --silent https://api.github.com/repos/rustdesk/rustdesk/releases/latest | jq --raw-output '.assets | map(select(.name | endswith("x86_64.rpm"))) | first | .browser_download_url')

wget $rustdesk_url -O /tmp/rustdesk.rpm

rpm-ostree install /tmp/rustdesk.rpm

#### Example for enabling a System Unit File
systemctl enable podman.socket

systemctl enable tailscaled.service

#systemctl enable libvirtd.service

systemctl enable sunshine-workaround.service

systemctl enable sshd.service

# Decrease the boot-time
systemctl disable NetworkManager-wait-online.service

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
