#!/bin/bash

cd /root

git clone https://github.com/taj-ny/kwin-effects-forceblur

cd kwin-effects-forceblur

mkdir build

cd build

cmake .. -DCMAKE_INSTALL_PREFIX=/usr

make -j$(nproc)

cpack -V -G RPM
