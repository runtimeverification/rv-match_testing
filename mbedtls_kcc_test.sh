#!/bin/bash
rm -rf mbedtls_kcc_test
mkdir mbedtls_kcc_test
cd mbedtls_kcc_test
STRTDIR=$(pwd)
wget https://tls.mbed.org/download/mbedtls-2.4.0-gpl.tgz\
tar -zxvf mbedtls-2.4.0-gpl.tgz
rm mbedtls-2.4.0-gpl.tgz
cd $STRTDIR/mbedtls-2.4.0
CC=kcc LD=kcc make |& tee kcc_make_out.txt
kcc -d -Wall -W -Wdeclaration-after-statement -I../include -D_FILE_OFFSET_BITS=64 -O2 -c net_sockets.c |& tee kcc_out.txt
mkdir kcc_compile_out
mv kcc_make_out.txt kcc_compile_out/
mv kcc_out.txt kcc_compile_out/
mv library/kcc_config kcc_compile_out/
cd $STRTDIR
mv mbedtls-2.4.0/kcc_compile_out/ .
cd kcc_compile_out/
k-bin-to-text kcc_config kcc_config.txt && grep -o "<k>.\{500\}" kcc_config.txt &> kcc_config_k_summary.txt
cd $STRTDIR
tar -czvf kcc_compile_out.tar.gz --exclude "kcc_config.txt" kcc_compile_out