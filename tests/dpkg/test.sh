#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh

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
cd $STRTDIR/dpkg
mkdir kcc_compile_out
mv kcc_configure_out.txt kcc_compile_out/
mv kcc_make_out.txt kcc_compile_out/
mv kcc_config kcc_compile_out/kcc_config_from_make
mv dpkg-split/kcc_config kcc_compile_out/
cd $STRTDIR
mv dpkg/kcc_compile_out .
# timothy@timothy-RVMatch-VirtualBox:~/Desktop/dpkg$ diff kcc_config dpkg-split/kcc_config
# Binary files kcc_config and dpkg-split/kcc_config differ
echo "dpkg script is not yet finished."
