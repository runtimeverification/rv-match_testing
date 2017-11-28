#!/bin/bash
. prepare.sh $(basename $(dirname $BASH_SOURCE))

git clone https://source.isc.org/git/bind9.git
cd bind9
git checkout 63270d33f1103f6193aebd6c205b78064b4cdfe5
autoreconf
./configure CC=kcc LD=kcc |& tee kcc_configure_out.txt
make |& tee kcc_make_out.txt
kcc -d -I/home/timothy/Desktop/bind9 -I../.. -I. -I../../lib/dns -Iinclude -I/home/timothy/Desktop/bind9/lib/dns/include -I../../lib/dns/include -I/home/timothy/Desktop/bind9/lib/isc/include -I../../lib/isc -I../../lib/isc/include -I../../lib/isc/unix/include -I../../lib/isc/pthreads/include -I../../lib/isc/noatomic/include -D_REENTRANT -DUSE_MD5 -DOPENSSL -D_GNU_SOURCE -g -fPIC -c adb.c |& tee kcc_out.txt
mv_kcc_out
mv lib/dns/kcc_config $log_dir
cd $build_dir
#tar -czvf kcc_compile_out.tar.gz kcc_compile_out
