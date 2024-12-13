#!/bin/bash

INSTALL=$(cat /tmp/packages.d/install.json | jq -r '[.[]] | join(" ")')
UNINSTALL=$(cat /tmp/packages.d/uninstall.json | jq -r '[.[]] | join(" ")')

rpm-ostree install $INSTALL
rpm-ostree uninstall $UNINSTALL