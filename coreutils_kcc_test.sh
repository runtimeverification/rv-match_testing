rm -rf coreutils-8.28_kcc_test
mkdir coreutils-8.28_kcc_test
cd coreutils-8.28_kcc_test
STRTDIR=$(pwd)
wget http://ftp.gnu.org/gnu/coreutils/coreutils-8.28.tar.xz
tar xf coreutils-8.28.tar.xz
rm coreutils-8.28.tar.xz
cd $STRTDIR/coreutils-8.28
autoreconf
cd $STRTDIR/coreutils-8.28
./configure CC=kcc LD=kcc --disable-threads |& tee kcc_configure_out.txt
cd $STRTDIR/coreutils-8.28
make |& tee kcc_make_out.txt
cd $STRTDIR/coreutils-8.28
kcc -d -I. -I./lib -Ilib -I./lib -Isrc -I./src -g -MT lib/parse-datetime.o -MD -MP -MF lib/.deps/parse-datetime.Tpo -c -o lib/parse-datetime.o lib/parse-datetime.c |& tee kcc_out.txt
cd $STRTDIR/coreutils-8.28
mkdir kcc_compile_out
mv kcc_configure_out.txt kcc_compile_out/
mv kcc_make_out.txt kcc_compile_out/
mv kcc_out.txt kcc_compile_out/
mv config kcc_compile_out/
cd $STRTDIR
mv coreutils-8.28/kcc_compile_out/ .
tar -czvf kcc_compile_out.tar.gz kcc_compile_out/
