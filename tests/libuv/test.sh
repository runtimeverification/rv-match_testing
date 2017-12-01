#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh

git clone https://github.com/libuv/libuv.git
build_dir=$base_dir/libuv/
cd $build_dir
git checkout 719dfecf95b0c74af6494f05049e56d5771ebfae
bash autogen.sh
set -o pipefail
./configure CC=kcc LD=kcc |& tee kcc_configure_out.txt ; configure_success="$?"
make |& tee kcc_make_out.txt ; make_success="$?"
kcc -d -DPACKAGE_NAME="libuv" -DPACKAGE_TARNAME="libuv" -DPACKAGE_VERSION="1.15.0" -DPACKAGE_STRING="libuv 1.15.0" -DPACKAGE_BUGREPORT="https://github.com/libuv/libuv/issues" -DPACKAGE_URL="" -DPACKAGE="libuv" -DVERSION="1.15.0" -DSUPPORT_FLAG_VISIBILITY=1 -DSTDC_HEADERS=1 -DHAVE_SYS_TYPES_H=1 -DHAVE_SYS_STAT_H=1 -DHAVE_STDLIB_H=1 -DHAVE_STRING_H=1 -DHAVE_MEMORY_H=1 -DHAVE_STRINGS_H=1 -DHAVE_INTTYPES_H=1 -DHAVE_STDINT_H=1 -DHAVE_UNISTD_H=1 -DHAVE_DLFCN_H=1 -DLT_OBJDIR=".libs/" -DHAVE_LIBDL=1 -DHAVE_LIBNSL=1 -DHAVE_LIBPTHREAD=1 -DHAVE_LIBRT=1 -I. -I./include -I./src -I./src/unix -g -pedantic -g -std=gnu89 -Wall -Wextra -Wno-unused-parameter -Wstrict-prototypes -D_GNU_SOURCE -g -pedantic -g -std=gnu89 -Wall -Wextra -Wno-unused-parameter -Wstrict-prototypes -MT src/unix/libuv_la-async.lo -MD -MP -MF src/unix/.deps/libuv_la-async.Tpo -c src/unix/async.c -DPIC -o src/unix/.libs/libuv_la-async.o |& tee kcc_out.txt
mkdir kcc_compile_out
mv kcc_configure_out.txt kcc_compile_out/
mv kcc_make_out.txt kcc_compile_out/
mv kcc_config kcc_compile_out/
cd $build_dir
mv libuv/kcc_compile_out/ .
cd kcc_compile_out/
k-bin-to-text kcc_config kcc_config.txt && grep -o "<k>.\{500\}" kcc_config.txt &> kcc_config_k_summary.txt
echo "==== kcc configure status reported:"$configure_success
echo $configure_success > kcc_configure_success.ini
echo "==== kcc make status reported:"$make_success
echo $make_success > kcc_make_success.ini
cd $build_dir
tar -czvf kcc_compile_out.tar.gz --exclude "kcc_config.txt" kcc_compile_out/
