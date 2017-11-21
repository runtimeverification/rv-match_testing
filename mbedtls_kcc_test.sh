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
mv library/config kcc_compile_out/
cd $STRTDIR
mv mbedtls-2.4.0/kcc_compile_out/ .
tar -czvf kcc_compile_out.tar.gz kcc_compile_out
