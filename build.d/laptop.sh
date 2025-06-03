#!/bin/bash

set -ouex pipefail

rpm-ostree uninstall tuned-ppd tuned
rpm-ostree install tlp powertop

systemctl enable tlp.service
