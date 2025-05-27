#!/bin/bash

download_url=$(curl -s https://api.github.com/repos/asdf-vm/asdf/releases/latest | jq --raw-output '.assets | map(select(.name | endswith("-linux-amd64.tar.gz"))) | first | .browser_download_url')
wget $download_url -O /tmp/asdf-package.tar.gz
tar -xzvf /tmp/asdf-package.tar.gz -C /usr/bin asdf

chmod 755 /usr/bin/asdf