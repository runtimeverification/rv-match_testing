#!/bin/bash
rm -rf netdata_kcc_test/
mkdir netdata_kcc_test/
cd netdata_kcc_test/
STRTDIR=$(pwd)
git clone https://github.com/firehol/netdata.git
cd netdata/
git checkout 2bbde1ba150b0d6fb66cd01d94b26da0181fd45e
autoscan
aclocal
autoheader
autoreconf
automake --add-missing
autoreconf
./configure CC=kcc LD=kcc |& tee kcc_configure_out.txt
make |& tee kcc_make_out.txt
cd $STRTDIR/netdata/src/
kcc -d -g -pthread -o apps.plugin apps_plugin.o avl.o clocks.o common.o log.o procfile.o web_buffer.o -lm
cd $STRTDIR/netdata/
mkdir kcc_compile_out
mv kcc_configure_out.txt kcc_compile_out/
mv kcc_make_out.txt kcc_compile_out/
mv src/kcc_config kcc_compile_out/
cd $STRTDIR
mv $STRTDIR/netdata/kcc_compile_out/ .
tar -czvf kcc_compile_out.tar.gz kcc_compile_out
