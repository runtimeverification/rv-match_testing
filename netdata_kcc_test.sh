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
set -o pipefail
./configure CC=kcc LD=kcc |& tee kcc_configure_out.txt ; configure_success="$?"
make |& tee kcc_make_out.txt ; make_success="$?"
cd $STRTDIR/netdata/src/
kcc -d -g -pthread -o apps.plugin apps_plugin.o avl.o clocks.o common.o log.o procfile.o web_buffer.o -lm
cd $STRTDIR/netdata/
mkdir kcc_compile_out
mv kcc_configure_out.txt kcc_compile_out/
mv kcc_make_out.txt kcc_compile_out/
mv src/kcc_config kcc_compile_out/
cd $STRTDIR
mv $STRTDIR/netdata/kcc_compile_out/ .
cd kcc_compile_out/
k-bin-to-text kcc_config kcc_config.txt && grep -o "<k>.\{500\}" kcc_config.txt &> kcc_config_k_summary.txt
echo "==== kcc configure status reported:"$configure_success
echo $configure_success > kcc_configure_success.ini
echo "==== kcc make status reported:"$make_success
echo $make_success > kcc_make_success.ini
cd $STRTDIR
tar -czvf kcc_compile_out.tar.gz --exclude "kcc_config.txt" kcc_compile_out
