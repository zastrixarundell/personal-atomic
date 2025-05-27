#!/bin/bash

dnf copr enable -y lizardbyte/beta &

(
    curl -Lo /etc/yum.repos.d/cloudflare-warp.repo https://pkg.cloudflareclient.com/cloudflare-warp-ascii.repo
) &

(
    curl -Lo /etc/yum.repos.d/tailscale.repo https://pkgs.tailscale.com/stable/fedora/tailscale.repo &&
    sed -i 's@gpgcheck=1@gpgcheck=0@g' /etc/yum.repos.d/tailscale.repo
) &

(
    rustdesk_url=$(curl --silent https://api.github.com/repos/rustdesk/rustdesk/releases/latest | jq --raw-output '.assets | map(select(.name | endswith("x86_64.rpm"))) | first | .browser_download_url') &&
    wget $rustdesk_url -O /tmp/rustdesk.rpm
) &

wait

