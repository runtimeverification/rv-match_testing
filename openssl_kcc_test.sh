rm -rf openssl_kcc_test
mkdir openssl_kcc_test
cd openssl_kcc_test
STRTDIR=$(pwd)
git clone https://github.com/openssl/openssl.git
cd openssl
git checkout 7a908204ed3afe1379151c6d090148edb2fcc87e
CC=kcc LD=kcc ./config 2>&1 | tee kcc_config_out.txt
make 2>&1 | tee kcc_make_out.txt
mkdir kcc_compile_out
mv kcc_config_out.txt kcc_compile_out
mv kcc_make_out.txt kcc_compile_out
mv config kcc_compile_out
cd $STRTDIR
mv openssl/kcc_compile_out .
tar -czvf kcc_compile_out.tar.gz kcc_compile_out
cd $STRDIR/..
