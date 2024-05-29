#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"


### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

#curl -Lo /usr/bin/copr https://raw.githubusercontent.com/ublue-os/COPR-command/main/copr && \
#    chmod +x /usr/bin/copr && \
#    /usr/bin/copr enable matte-schwartz/sunshine

KERNEL_VERSION="6.7.11"

KERNEL_VERSION_NUMBER="200.fc39"

curl -Lo /tmp/kernel-$KERNEL_VERSION-$KERNEL_VERSION_NUMBER.x86_64.rpm https://kojipkgs.fedoraproject.org/packages/kernel/$KERNEL_VERSION/$KERNEL_VERSION_NUMBER/x86_64/kernel-$KERNEL_VERSION-$KERNEL_VERSION_NUMBER.x86_64.rpm
curl -Lo /tmp/kernel-modules-$KERNEL_VERSION-$KERNEL_VERSION_NUMBER.x86_64.rpm https://kojipkgs.fedoraproject.org/packages/kernel/$KERNEL_VERSION/$KERNEL_VERSION_NUMBER/x86_64/kernel-modules-$KERNEL_VERSION-$KERNEL_VERSION_NUMBER.x86_64.rpm
curl -Lo /tmp/kernel-modules-extra-$KERNEL_VERSION-$KERNEL_VERSION_NUMBER.x86_64.rpm https://kojipkgs.fedoraproject.org/packages/kernel/$KERNEL_VERSION/$KERNEL_VERSION_NUMBER/x86_64/kernel-modules-extra-$KERNEL_VERSION-$KERNEL_VERSION_NUMBER.x86_64.rpm
curl -Lo /tmp/kernel-core-$KERNEL_VERSION-$KERNEL_VERSION_NUMBER.x86_64.rpm https://kojipkgs.fedoraproject.org/packages/kernel/$KERNEL_VERSION/$KERNEL_VERSION_NUMBER/x86_64/kernel-core-$KERNEL_VERSION-$KERNEL_VERSION_NUMBER.x86_64.rpm
curl -Lo /tmp/kernel-modules-core-$KERNEL_VERSION-$KERNEL_VERSION_NUMBER.x86_64.rpm https://kojipkgs.fedoraproject.org/packages/kernel/$KERNEL_VERSION/$KERNEL_VERSION_NUMBER/x86_64/kernel-modules-core-$KERNEL_VERSION-$KERNEL_VERSION_NUMBER.x86_64.rpm

rpm-ostree override replace \
  /tmp/kernel-{,modules-,modules-extra-,modules-core-,core-}$KERNEL_VERSION-$KERNEL_VERSION_NUMBER.x86_64.rpm

curl -Lo /etc/yum.repos.d/_copr_matte-schwartz-sunshine.repo https://copr.fedorainfracloud.org/coprs/matte-schwartz/sunshine/repo/fedora-"${RELEASE}"/matte-schwartz-sunshine-fedora-"${RELEASE}".repo && \
	curl -Lo /etc/yum.repos.d/vscode.repo https://raw.githubusercontent.com/zastrixarundell/personal-kinoite/main/repos/vscode.repo && \
	curl -Lo /etc/yum.repos.d/tailscale.repo https://pkgs.tailscale.com/stable/fedora/tailscale.repo && \
	sed -i 's@gpgcheck=1@gpgcheck=0@g' /etc/yum.repos.d/tailscale.repo

rpm-ostree install code corectrl goverlay ncdu podman-compose sunshine tailscale wireshark WoeUSB zsh virt-manager fastfetch

rpm-ostree uninstall firefox firefox-langpacks

#### Example for enabling a System Unit File
systemctl enable podman.socket

setsebool -P nis_enabled 1

systemctl enable tailscaled.service
systemctl enable libvirtd.service
systemctl enable sunshine-workaround.service
