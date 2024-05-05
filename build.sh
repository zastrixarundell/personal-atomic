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

curl -Lo /etc/yum.repos.d/_copr_matte-schwartz-sunshine.repo https://copr.fedorainfracloud.org/coprs/matte-schwartz/sunshine/repo/fedora-"${RELEASE}"/matte-schwartz-sunshine-fedora-"${RELEASE}".repo && \
	curl -Lo /etc/yum.repos.d/vscode.repo https://raw.githubusercontent.com/zastrixarundell/personal-kinoite/main/repos/vscode.repo && \
	curl -Lo /etc/yum.repos.d/teamviewer.repo https://raw.githubusercontent.com/zastrixarundell/personal-kinoite/main/repos/teamviewer.repo && \
	curl -Lo /etc/yum.repos.d/tailscale.repo https://pkgs.tailscale.com/stable/fedora/tailscale.repo && \
	sed -i 's@gpgcheck=1@gpgcheck=0@g' /etc/yum.repos.d/tailscale.repo

setsebool -P nis_enabled 1

rpm-ostree install code
rpm-ostree install corectrl
rpm-ostree install goverlay
rpm-ostree install ncdu
rpm-ostree install podman-compose
rpm-ostree install sunshine
rpm-ostree install tailscale
rpm-ostree install teamviewer
rpm-ostree install wireshark
rpm-ostree install WoeUSB
rpm-ostree install zsh
rpm-ostree install virt-manager

# rpm-ostree uninstall firefox firefox-langpacks

# this installs a package from fedora repos
#rpm-ostree install screen

# this would install a package from rpmfusion
# rpm-ostree install vlc

#### Example for enabling a System Unit File

systemctl enable podman.socket

echo "Setting up syslink for teamviewer"

ln -s /usr/lib/opt/teamviewer/tv_bin/script/teamviewerd.service /etc/systemd/system/teamviewerd.service

systemctl enable teamviewerd.service

systemctl enable tailscaled.service
