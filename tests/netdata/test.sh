#!/bin/bash
. prepare.sh $(basename $(dirname $BASH_SOURCE))

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
cd $build_dir/netdata/src/
kcc -d -g -pthread -o apps.plugin apps_plugin.o avl.o clocks.o common.o log.o procfile.o web_buffer.o -lm
cd $build_dir/netdata/
mv_kcc_out
mv src/kcc_config $log_dir
cd $log_dir
k-bin-to-text kcc_config kcc_config.txt && grep -o "<k>.\{500\}" kcc_config.txt &> kcc_config_k_summary.txt
cd $build_dir
#tar -czvf kcc_compile_out.tar.gz --exclude "kcc_config.txt" kcc_compile_out
