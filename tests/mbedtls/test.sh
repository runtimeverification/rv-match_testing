#!/bin/bash
. prepare.sh $(basename $(dirname $BASH_SOURCE))

wget https://tls.mbed.org/download/mbedtls-2.4.0-gpl.tgz\
tar -zxvf mbedtls-2.4.0-gpl.tgz
rm mbedtls-2.4.0-gpl.tgz
cd $build_dir/mbedtls-2.4.0
CC=kcc LD=kcc make |& tee kcc_make_out.txt
kcc -d -Wall -W -Wdeclaration-after-statement -I../include -D_FILE_OFFSET_BITS=64 -O2 -c net_sockets.c |& tee kcc_out.txt
mv_kcc_out
mv library/kcc_config $log_dir
cd $build_dir
#tar -czvf kcc_compile_out.tar.gz kcc_compile_out
