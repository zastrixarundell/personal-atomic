# Personal Atomic

## Instructions to setup

### Signed images

Upon a fresh installation you should run:
```bash
rpm-ostree rebase ostree-unverified-registry:docker.io/zastrix/personal-atomic:latest
```

After a system reboot you can run:

```bash
rpm-ostree rebase ostree-image-signed:docker.io/zastrix/personal-atomic:latest
```

### Commands

|Abbreviation|Description|
|-|-|
|`install_brew`|Install brew onto the system (interactive)|
|`elixir_setup`|Setup distrobox container for compiling elixir/erlang|
|`cdtemp`|Create and enter a unique directory in `/tmp/X`|
|`compress`|Compress btrfs directory|
|`comp`|Compare compression for btrfs directory|
|`rpm-ostree-diff`|Show rpm-ostree changes without rebooting|
|`amend`|Amend git commit|
|`gsp`|Push to git stash with message|
|`gp`|Push to git origin with the current HEAD (works for new branches)|
|`gc`|Git commit current changes|
|`gca`|Add everything and then commit|
|`gcm`|Same as `gc` but with message|
|`gcam`|Same as `gca` but with message|

# Purpose

## What does this achieve

This is a system configuration for my own personal liking. It's based off the 'vanilla' Kinoite project, so no uBlue integrated stuff. This project contains:

* Tools for development
* Tools for QoL
* Configs for QoL
* Tools for virtualization
* Hardware and Software optimizations
* Workaround for streaming fixes
* Additional drivers and codecs
* Unstable version based off Rawhide for testing the latest kernel

## How to Use

Once Fedora Kinoite is installed, open but the terminal and run:

```bash
rpm-ostree rebase ostree-unverified-registry:docker.io/zastrix/personal-atomic:latest
```

Once that is done, you can reboot your system and it should automatically load up.

### User groups

Due to an [issue with rpm-ostree](https://github.com/coreos/rpm-ostree/issues/49), it's not _super_ easy to add a user to a user group.

To add a user to the `libvirt` group, you have to do this set of commands:

```bash
grep -E '^libvirt:' /usr/lib/group >> /etc/group
usermod -aG libvirt username
```

## Information about building

Some rpms need to be built in-place due to requirements of the latest kwin and such.

Beacuse of that, there are multiple `Containerfile*` files:

1) `Containerfile.rpms` which build the required rpms and pushes it as an artifact
2) `Containerfile` the main file which also used the pre-downloaded artifacts.