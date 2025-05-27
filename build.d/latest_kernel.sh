#!/bin/bash

# Install the latest version of the kernel
CLEAN_KERNEL_VERSION=$(curl -Ls https://packages.fedoraproject.org/pkgs/kernel/kernel/fedora-rawhide.html | grep '<title>' | sed -n 's/.*kernel-\([^ ]*\).*/\1/p')

KERNEL_VERSION=$(echo $CLEAN_KERNEL_VERSION | sed -n 's/\([0-9]\+\.[0-9]\+\.[0-9]\+\).*/\1/p')

KERNEL_VERSION_NUMBER=$(echo $CLEAN_KERNEL_VERSION | sed "s/$KERNEL_VERSION-//")

curl -Los /tmp/kernel-$KERNEL_VERSION-$KERNEL_VERSION_NUMBER.x86_64.rpm https://kojipkgs.fedoraproject.org/packages/kernel/$KERNEL_VERSION/$KERNEL_VERSION_NUMBER/x86_64/kernel-$KERNEL_VERSION-$KERNEL_VERSION_NUMBER.x86_64.rpm &
curl -Los /tmp/kernel-modules-$KERNEL_VERSION-$KERNEL_VERSION_NUMBER.x86_64.rpm https://kojipkgs.fedoraproject.org/packages/kernel/$KERNEL_VERSION/$KERNEL_VERSION_NUMBER/x86_64/kernel-modules-$KERNEL_VERSION-$KERNEL_VERSION_NUMBER.x86_64.rpm &
curl -Los /tmp/kernel-modules-extra-$KERNEL_VERSION-$KERNEL_VERSION_NUMBER.x86_64.rpm https://kojipkgs.fedoraproject.org/packages/kernel/$KERNEL_VERSION/$KERNEL_VERSION_NUMBER/x86_64/kernel-modules-extra-$KERNEL_VERSION-$KERNEL_VERSION_NUMBER.x86_64.rpm &
curl -Los /tmp/kernel-core-$KERNEL_VERSION-$KERNEL_VERSION_NUMBER.x86_64.rpm https://kojipkgs.fedoraproject.org/packages/kernel/$KERNEL_VERSION/$KERNEL_VERSION_NUMBER/x86_64/kernel-core-$KERNEL_VERSION-$KERNEL_VERSION_NUMBER.x86_64.rpm &
curl -Los /tmp/kernel-modules-core-$KERNEL_VERSION-$KERNEL_VERSION_NUMBER.x86_64.rpm https://kojipkgs.fedoraproject.org/packages/kernel/$KERNEL_VERSION/$KERNEL_VERSION_NUMBER/x86_64/kernel-modules-core-$KERNEL_VERSION-$KERNEL_VERSION_NUMBER.x86_64.rpm &

wait

rpm-ostree override replace \
    /tmp/kernel-{,modules-,modules-extra-,modules-core-,core-}$KERNEL_VERSION-$KERNEL_VERSION_NUMBER.x86_64.rpm