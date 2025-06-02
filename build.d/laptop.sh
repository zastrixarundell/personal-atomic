#!/bin/bash

rpm-ostree uninstall tuned-profiles-realtime tuned-ppd tuned
rpm-ostree install tld

systemctl enable tld.service
