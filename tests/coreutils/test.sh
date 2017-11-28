#!/bin/bash
. prepare.sh $(basename $(dirname $BASH_SOURCE))
VERSION=8.28

wget http://ftp.gnu.org/gnu/coreutils/coreutils-$VERSION.tar.xz
tar xf coreutils-$VERSION.tar.xz
rm coreutils-$VERSION.tar.xz
cd $build_dir/coreutils-$VERSION
autoreconf
cd $build_dir/coreutils-$VERSION
./configure CC=kcc LD=kcc --disable-threads |& tee kcc_configure_out.txt
cd $build_dir/coreutils-$VERSION
make |& tee kcc_make_out.txt
cd $build_dir/coreutils-$VERSION
kcc -d -I. -I./lib -Ilib -I./lib -Isrc -I./src -g -MT lib/parse-datetime.o -MD -MP -MF lib/.deps/parse-datetime.Tpo -c -o lib/parse-datetime.o lib/parse-datetime.c |& tee kcc_out.txt
cd $build_dir/coreutils-$VERSION
mv_kcc_out
cd $build_dir
#tar -czvf kcc_compile_out.tar.gz kcc_compile_out/
