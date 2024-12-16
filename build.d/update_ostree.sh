#!/bin/bash

INSTALL=$(cat /tmp/packages.d/install.json | jq -r '[.[]] | join(" ")')
UNINSTALL=$(cat /tmp/packages.d/uninstall.json | jq -r '[.[]] | join(" ")')

rpm-ostree install \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

rpm-ostree install $INSTALL
rpm-ostree uninstall $UNINSTALL