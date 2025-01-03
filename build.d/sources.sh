#!/bin/bash

curl -Lo /etc/yum.repos.d/_copr_matte-schwartz-sunshine.repo https://copr.fedorainfracloud.org/coprs/matte-schwartz/sunshine/repo/fedora-${RELEASE}/matte-schwartz-sunshine-fedora-${RELEASE}.repo &

curl -Lo /etc/yum.repos.d/_copr_kylegospo_bees.repo https://copr.fedorainfracloud.org/coprs/kylegospo/bees/repo/fedora-${RELEASE}/kylegospo-bees-fedora-${RELEASE}.repo &

(
    curl -Lo /etc/yum.repos.d/tailscale.repo https://pkgs.tailscale.com/stable/fedora/tailscale.repo &&
    sed -i 's@gpgcheck=1@gpgcheck=0@g' /etc/yum.repos.d/tailscale.repo
) &

(
    rustdesk_url=$(curl --silent https://api.github.com/repos/rustdesk/rustdesk/releases/latest | jq --raw-output '.assets | map(select(.name | endswith("x86_64.rpm"))) | first | .browser_download_url') &&
    wget $rustdesk_url -O /tmp/rustdesk.rpm
) &

wait

