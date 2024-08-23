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

#rpm-ostree override remove mesa-va-drivers-freeworld

#rpm-ostree override --experimental replace \
#	mesa-libglapi mesa-libxatracker mesa-dri-drivers \
#	mesa-libgbm mesa-libEGL mesa-libGL \
#	mesa-filesystem mesa-vdpau-drivers mesa-vulkan-drivers \
#	--from repo=mesa-git

#rpm-ostree install mesa-va-drivers

# Setting custom repositories

curl -Lo /etc/yum.repos.d/_copr_matte-schwartz-sunshine.repo https://copr.fedorainfracloud.org/coprs/matte-schwartz/sunshine/repo/fedora-"${RELEASE}"/matte-schwartz-sunshine-fedora-"${RELEASE}".repo

curl -Lo /etc/yum.repos.d/tailscale.repo https://pkgs.tailscale.com/stable/fedora/tailscale.repo

sed -i 's@gpgcheck=1@gpgcheck=0@g' /etc/yum.repos.d/tailscale.repo

# virt-manager

rpm-ostree install \
	code \
	corectrl \
 	goverlay \
  	ncdu \
   	podman-compose \
	sunshine \
	tailscale \
	wireshark\
	WoeUSB \
	zsh \
 	fastfetch \
  	krdp \
   	krdc \
	realtime-setup \
	android-tools \
	akmod-v4l2loopback

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
