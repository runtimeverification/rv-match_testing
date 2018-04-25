#!/bin/bash
# https://github.com/NLnetLabs/nsd.git
# ee44df629568c7d01842cc8c56de1840825bf211
sudo apt -y install libevent-dev bison flex
autoreconf
./configure CC=kcc LD=kcc
make -j`nproc`
