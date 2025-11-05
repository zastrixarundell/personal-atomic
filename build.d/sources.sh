#!/bin/bash

set -ouex pipefail

dnf copr enable -y lizardbyte/beta &

(
    curl -Lso /etc/yum.repos.d/docker-ce.repo https://download.docker.com/linux/fedora/docker-ce.repo
) &

(
    curl -Lso /etc/yum.repos.d/tailscale.repo https://pkgs.tailscale.com/stable/fedora/tailscale.repo &&
    sed -i 's@gpgcheck=1@gpgcheck=0@g' /etc/yum.repos.d/tailscale.repo
) &

(
    rustdesk_url=$(curl -s https://api.github.com/repos/rustdesk/rustdesk/releases/latest | jq --raw-output '.assets | map(select(.name | endswith("x86_64.rpm"))) | first | .browser_download_url') &&
    wget $rustdesk_url -O /opt/rpms/rustdesk.rpm
) &

wait

