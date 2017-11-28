#!/bin/bash
rm -rf dpkg_kcc_test/
mkdir dpkg_kcc_test/
cd dpkg_kcc_test/
STRTDIR=$(pwd)
git clone git://anonscm.debian.org/dpkg/dpkg.git
cd dpkg
git checkout b9798daaa596ad5d539bcdd5ca89de1cb0b81697
autoscan
aclocal
autoheader
autoreconf
automake --add-missing
autoreconf -vif
./configure CC=kcc LD=kcc |& tee kcc_configure_out.txt
make |& tee kcc_make_out.txt
cd dpkg-split
kcc -d -g -O1 -o dpkg-split info.o join.o main.o queue.o split.o ../lib/dpkg/.libs/libdpkg.a |& tee kcc_out.txt
cd ..
# timothy@timothy-RVMatch-VirtualBox:~/Desktop/dpkg$ diff kcc_config dpkg-split/kcc_config
# Binary files kcc_config and dpkg-split/kcc_config differ
echo "dpkg script is not yet finished."
