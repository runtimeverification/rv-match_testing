#!/bin/bash
# https://github.com/mirror/wget.git
# 6aa6b669efbef62f60471c18e7fdef0206f92337
./bootstrap
sudo apt -y install autopoint texinfo gperf libgnutls-dev
./configure --disable-threads CC=kcc LD=kcc
make -j`nproc`
