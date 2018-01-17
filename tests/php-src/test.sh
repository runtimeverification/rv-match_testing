#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

# TODO
_download() {
    git clone https://github.com/php/php-src.git
    cd php-src/
    git checkout edc77d5d00ec3ee3c547e7e08ae4e36fc11deb49
    echo "Force new DL"
}

_build() {
    cd php-src/
    autoscan
    aclocal
    autoheader
    autoreconf
    ./buildconf CC=$compiler LD=$compiler
    #sudo apt install libxml2-dev
    ./configure CC=$compiler LD=$compiler |& tee kcc_configure_out.txt ; configure_success="$?"
    echo "PHP-SRC DEBUG"
    cat config.log
    make |& tee kcc_make_out.txt ; make_success="$?"
}

init
