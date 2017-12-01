#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh

wget https://tls.mbed.org/download/mbedtls-2.4.0-gpl.tgz\
tar -zxvf mbedtls-2.4.0-gpl.tgz
rm mbedtls-2.4.0-gpl.tgz
build_dir=$base_dir/mbedtls-2.4.0
cd $build_dir
set -o pipefail
CC=kcc LD=kcc make |& tee kcc_make_out.txt ; make_success="$?"
kcc -d -Wall -W -Wdeclaration-after-statement -I../include -D_FILE_OFFSET_BITS=64 -O2 -c net_sockets.c |& tee kcc_out.txt
mkdir kcc_compile_out
mv kcc_make_out.txt kcc_compile_out/
mv kcc_out.txt kcc_compile_out/
mv library/kcc_config kcc_compile_out/
cd $build_dir
mv mbedtls-2.4.0/kcc_compile_out/ .
cd kcc_compile_out/
k-bin-to-text kcc_config kcc_config.txt && grep -o "<k>.\{500\}" kcc_config.txt &> kcc_config_k_summary.txt
echo "==== kcc make status reported:"$make_success
echo $make_success > kcc_make_success.ini
cd $build_dir
tar -czvf kcc_compile_out.tar.gz --exclude "kcc_config.txt" kcc_compile_out
