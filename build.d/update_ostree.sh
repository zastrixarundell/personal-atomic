#!/bin/bash

set -ouex pipefail

RELEASE=$(rpm -E %fedora)

INSTALL=$(cat /tmp/packages.d/install.json | jq -r '[.[]] | join(" ")')
UNINSTALL=$(cat /tmp/packages.d/uninstall.json | jq -r '[.[]] | join(" ")')

rpm-ostree install \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$RELEASE.noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$RELEASE.noarch.rpm

rpm-ostree uninstall $UNINSTALL
rpm-ostree install $INSTALL
