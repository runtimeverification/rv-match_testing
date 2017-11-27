# This script is incomplete
rm -rf php-src_kcc_test
mkdir php-src_kcc_test
cd php-src_kcc_test
STRTDIR=$(pwd)
git clone https://github.com/php/php-src.git
cd php-src
git checkout edc77d5d00ec3ee3c547e7e08ae4e36fc11deb49
autoscan
aclocal
autoheader
autoreconf
./buildconf CC=kcc LD=kcc
#sudo apt install libxml2-dev
./configure CC=kcc LD=kcc |& tee kcc_configure_out.txt
make
