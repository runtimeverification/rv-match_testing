#!/bin/bash
VERSION=5.3.4

tar=lua-$VERSION.tar.gz
tar_tests=lua-$VERSION-tests.tar.gz

# rm -rf lua-${VERSION}_kcc_test
mkdir -p lua-${VERSION}_kcc_test
cd lua-${VERSION}_kcc_test
STRTDIR=$(pwd)
if [[ ! -f $tar ]]; then
  wget http://www.lua.org/ftp/$tar
fi
tar -xvzf $tar
rm $tar
cd $STRTDIR/lua-$VERSION
make linux CC=kcc LD=kcc |& tee kcc_make_out.txt
kcc -d -O2 -Wall -Wextra -DLUA_COMPAT_5_2 -DLUA_USE_LINUX -c -o src/luac.o src/luac.c |& tee kcc_out.txt
mkdir kcc_compile_out
mv kcc_make_out.txt kcc_compile_out/
mv kcc_out.txt kcc_compile_out/
cd $STRTDIR
wget https://www.lua.org/tests/$tar_tests
tar -xvzf $tar_tests
rm $tar_tests
cd $STRTDIR/lua-$VERSION-tests
$STRTDIR/lua-$VERSION/src/lua all.lua |& tee kcc_runtime.txt
mkdir kcc_runtime_out
mv kcc_runtime.txt kcc_runtime_out/
mv config kcc_runtime_out/
cd $STRTDIR
mkdir kcc_all
mv $STRTDIR/lua-$VERSION/kcc_compile_out kcc_all/
mv $STRTDIR/lua-$VERSION-tests/kcc_runtime_out kcc_all/
tar -czvf kcc_all.tar.gz kcc_all/
