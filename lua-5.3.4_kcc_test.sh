#!/bin/bash
# rm -rf lua-5.3.4_kcc_test
mkdir -p lua-5.3.4_kcc_test
cd lua-5.3.4_kcc_test
STRTDIR=$(pwd)
if [[ ! -f lua-5.3.4.tar.gz ]]; then
  wget http://www.lua.org/ftp/lua-5.3.4.tar.gz
fi
tar -xvzf lua-5.3.4.tar.gz
rm lua-5.3.4.tar.gz
cd $STRTDIR/lua-5.3.4
make linux CC=kcc LD=kcc |& tee kcc_make_out.txt
kcc -d -O2 -Wall -Wextra -DLUA_COMPAT_5_2 -DLUA_USE_LINUX -c -o src/luac.o src/luac.c |& tee kcc_out.txt
mkdir kcc_compile_out
mv kcc_make_out.txt kcc_compile_out/
mv kcc_out.txt kcc_compile_out/
cd $STRTDIR
wget https://www.lua.org/tests/lua-5.3.4-tests.tar.gz
tar -xvzf lua-5.3.4-tests.tar.gz
rm lua-5.3.4-tests.tar.gz
cd $STRTDIR/lua-5.3.4-tests
$STRTDIR/lua-5.3.4/src/lua all.lua |& tee kcc_runtime.txt
mkdir kcc_runtime_out
mv kcc_runtime.txt kcc_runtime_out/
mv kcc_config kcc_runtime_out/
cd $STRTDIR
mkdir kcc_all
mv $STRTDIR/lua-5.3.4/kcc_compile_out kcc_all/
mv $STRTDIR/lua-5.3.4-tests/kcc_runtime_out kcc_all/
tar -czvf kcc_all.tar.gz --exclude "kcc_config.txt" kcc_all/
