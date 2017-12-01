#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh

# TODO
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
