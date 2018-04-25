#!/bin/bash
sudo apt -y install libssl-dev
# https://github.com/Tarsnap/scrypt.git
# 4e4f88ad775fc2ea5e59f38e191ac6f5b3e375c7
autoscan ; aclocal ; autoheader ; autoreconf
automake --add-missing
autoreconf
./configure CC=kcc LD=kcc
make -j`nproc`
./tests/test_scrypt
