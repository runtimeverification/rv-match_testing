#!/bin/bash
. prepare.sh $(basename $(dirname $BASH_SOURCE))
VERSION=5.3.4

tar=lua-$VERSION.tar.gz
tar_tests=lua-$VERSION-tests.tar.gz

if [[ ! -f $tar ]]; then
  wget http://www.lua.org/ftp/$tar
fi
tar -xvzf $tar
rm $tar
cd $build_dir/lua-$VERSION
make linux CC=kcc LD=kcc |& tee kcc_make_out.txt
kcc -d -O2 -Wall -Wextra -DLUA_COMPAT_5_2 -DLUA_USE_LINUX -c -o src/luac.o src/luac.c |& tee kcc_out.txt
mkdir kcc_compile_out
mv kcc_make_out.txt kcc_compile_out/
mv kcc_out.txt kcc_compile_out/
cd $build_dir
wget https://www.lua.org/tests/$tar_tests
tar -xvzf $tar_tests
rm $tar_tests
cd $build_dir/lua-$VERSION-tests
$build_dir/lua-$VERSION/src/lua all.lua |& tee kcc_runtime.txt
mkdir kcc_runtime_out
mv kcc_runtime.txt kcc_runtime_out/
mv config kcc_runtime_out/
cd $build_dir
mkdir kcc_all
mv $build_dir/lua-$VERSION/kcc_compile_out kcc_all/
mv $build_dir/lua-$VERSION-tests/kcc_runtime_out kcc_all/
tar -czvf kcc_all.tar.gz kcc_all/
