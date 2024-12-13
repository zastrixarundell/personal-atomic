#!/bin/bash

INSTALL=$(cat packages.d/install.json | jq -r '[.[] | "--install=" + .] | join(" ")')
UNINSTALL=$(cat packages.d/uninstall.json | jq -r '[.[] | "--uninstall=" + .] | join(" ")')

rpm-ostree update \
    $INSTALL \
    $UNINSTALL