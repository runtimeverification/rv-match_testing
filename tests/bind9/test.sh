#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh

git clone https://source.isc.org/git/bind9.git
cd bind9
git checkout 63270d33f1103f6193aebd6c205b78064b4cdfe5
autoreconf
set -o pipefail
./configure CC=kcc LD=kcc |& tee kcc_configure_out.txt ; configure_success="$?"
make |& tee kcc_make_out.txt ; make_success="$?"
#kcc -d -I/home/timothy/Desktop/bind9 -I../.. -I. -I../../lib/dns -Iinclude -I/home/timothy/Desktop/bind9/lib/dns/include -I../../lib/dns/include -I/home/timothy/Desktop/bind9/lib/isc/include -I../../lib/isc -I../../lib/isc/include -I../../lib/isc/unix/include -I../../lib/isc/pthreads/include -I../../lib/isc/noatomic/include -D_REENTRANT -DUSE_MD5 -DOPENSSL -D_GNU_SOURCE -g -fPIC -c adb.c |& tee kcc_out.txt
mv_kcc_out
mv lib/dns/kcc_config $log_dir
cd $log_dir
k-bin-to-text kcc_config kcc_config.txt && grep -o "<k>.\{500\}" kcc_config.txt &> kcc_config_k_summary.txt
echo "==== kcc configure status reported:"$configure_success
echo $configure_success > kcc_configure_success.ini
echo "==== kcc make status reported:"$make_success
echo $make_success > kcc_make_success.ini
cd $build_dir
tar -czvf kcc_compile_out.tar.gz --exclude "kcc_config.txt" $log_dir
