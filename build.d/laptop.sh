#!/bin/bash

set -ouex pipefail

rpm-ostree uninstall tuned-profiles-realtime tuned-ppd tuned
rpm-ostree install tlp

systemctl enable tlp.service
