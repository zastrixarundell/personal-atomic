#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

KERNEL_VERSION="6.12.0"

KERNEL_VERSION_NUMBER="0.rc0.20240923gitde5cb0dcb74c.9.fc42"

curl -Lo /tmp/kernel-$KERNEL_VERSION-$KERNEL_VERSION_NUMBER.x86_64.rpm https://kojipkgs.fedoraproject.org/packages/kernel/$KERNEL_VERSION/$KERNEL_VERSION_NUMBER/x86_64/kernel-$KERNEL_VERSION-$KERNEL_VERSION_NUMBER.x86_64.rpm
curl -Lo /tmp/kernel-modules-$KERNEL_VERSION-$KERNEL_VERSION_NUMBER.x86_64.rpm https://kojipkgs.fedoraproject.org/packages/kernel/$KERNEL_VERSION/$KERNEL_VERSION_NUMBER/x86_64/kernel-modules-$KERNEL_VERSION-$KERNEL_VERSION_NUMBER.x86_64.rpm
curl -Lo /tmp/kernel-modules-extra-$KERNEL_VERSION-$KERNEL_VERSION_NUMBER.x86_64.rpm https://kojipkgs.fedoraproject.org/packages/kernel/$KERNEL_VERSION/$KERNEL_VERSION_NUMBER/x86_64/kernel-modules-extra-$KERNEL_VERSION-$KERNEL_VERSION_NUMBER.x86_64.rpm
curl -Lo /tmp/kernel-core-$KERNEL_VERSION-$KERNEL_VERSION_NUMBER.x86_64.rpm https://kojipkgs.fedoraproject.org/packages/kernel/$KERNEL_VERSION/$KERNEL_VERSION_NUMBER/x86_64/kernel-core-$KERNEL_VERSION-$KERNEL_VERSION_NUMBER.x86_64.rpm
curl -Lo /tmp/kernel-modules-core-$KERNEL_VERSION-$KERNEL_VERSION_NUMBER.x86_64.rpm https://kojipkgs.fedoraproject.org/packages/kernel/$KERNEL_VERSION/$KERNEL_VERSION_NUMBER/x86_64/kernel-modules-core-$KERNEL_VERSION-$KERNEL_VERSION_NUMBER.x86_64.rpm

rpm-ostree override replace \
  /tmp/kernel-{,modules-,modules-extra-,modules-core-,core-}$KERNEL_VERSION-$KERNEL_VERSION_NUMBER.x86_64.rpm

curl -Lo /etc/yum.repos.d/_copr_matte-schwartz-sunshine.repo https://copr.fedorainfracloud.org/coprs/matte-schwartz/sunshine/repo/fedora-"${RELEASE}"/matte-schwartz-sunshine-fedora-"${RELEASE}".repo

curl -Lo /etc/yum.repos.d/tailscale.repo https://pkgs.tailscale.com/stable/fedora/tailscale.repo

sed -i 's@gpgcheck=1@gpgcheck=0@g' /etc/yum.repos.d/tailscale.repo

rpm-ostree install \
    code \
    corectrl \
    goverlay \
    ncdu \
    podman-compose \
    sunshine \
    tailscale \
    WoeUSB \
    fastfetch \
    realtime-setup \
    android-tools \
    qpwgraph

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

### Setting up pipewire for easyeffects under high CPU load

mkdir -p /etc/pipewire

cp /usr/share/pipewire/pipewire.conf /etc/pipewire/

sed -i 's/#default.clock.min-quantum   = 32/default.clock.min-quantum    = 1024/g'   /etc/pipewire/pipewire.conf
sed -i 's/#default.clock.max-quantum   = 2048/default.clock.max-quantum    = 1024/g' /etc/pipewire/pipewire.conf
