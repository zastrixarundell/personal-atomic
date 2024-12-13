#!/bin/bash

INSTALL=$(cat /tmp/packages.d/install.json | jq -r '[.[] | "--install=" + .] | join(" ")')
UNINSTALL=$(cat /tmp/packages.d/uninstall.json | jq -r '[.[] | "--uninstall=" + .] | join(" ")')

rpm-ostree update \
    $INSTALL \
    $UNINSTALL