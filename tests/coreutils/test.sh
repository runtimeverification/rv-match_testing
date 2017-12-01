#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh

wget http://ftp.gnu.org/gnu/coreutils/coreutils-8.28.tar.xz
tar xf coreutils-8.28.tar.xz
rm coreutils-8.28.tar.xz
cd $build_dir/coreutils-8.28
autoreconf
cd $build_dir/coreutils-8.28
./configure CC=kcc LD=kcc --disable-threads |& tee kcc_configure_out.txt
cd $build_dir/coreutils-8.28
make |& tee kcc_make_out.txt
cd $build_dir/coreutils-8.28
kcc -d -I. -I./lib -Ilib -I./lib -Isrc -I./src -g -MT lib/parse-datetime.o -MD -MP -MF lib/.deps/parse-datetime.Tpo -c -o lib/parse-datetime.o lib/parse-datetime.c |& tee kcc_out.txt
cd $build_dir/coreutils-8.28
mkdir kcc_compile_out
mv kcc_configure_out.txt kcc_compile_out/
mv kcc_make_out.txt kcc_compile_out/
mv kcc_out.txt kcc_compile_out/
mv kcc_config kcc_compile_out/
cd $build_dir
mv coreutils-8.28/kcc_compile_out/ .
cd kcc_compile_out
k-bin-to-text kcc_config kcc_config.txt && grep -o "<k>.\{500\}" kcc_config.txt &> kcc_config_k_summary.txt
cd $build_dir
tar -czvf kcc_compile_out.tar.gz --exclude "kcc_config.txt" kcc_compile_out/
