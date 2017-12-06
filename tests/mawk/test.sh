#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh

_download() {
    #sudo apt build-dep mawk
    apt source mawk
    rm mawk_1.3.3-17ubuntu2.diff.gz
    rm mawk_1.3.3-17ubuntu2.dsc
    rm mawk_1.3.3.orig.tar.gz
    cd mawk-1.3.3/
}

_build() {
    cd mawk-1.3.3/
    ./configure MATHLIB='/lib/x86_64-linux-gnu/libm.so.6' CC=$compiler LD=$compiler |& tee kcc_configure_out.txt ; configure_success="$?"
    make |& tee kcc_make_out.txt ; make_success="$?"
}

_export() {
    cd mawk-1.3.3/ && process_kcc_config
    cd mawk-1.3.3/ && mv kcc_* $log_dir
}

init
