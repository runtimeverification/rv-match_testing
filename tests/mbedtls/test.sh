#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh

_download() {
    wget https://tls.mbed.org/download/mbedtls-2.4.0-gpl.tgz
    tar -zxvf mbedtls-2.4.0-gpl.tgz
    rm mbedtls-2.4.0-gpl.tgz
}

_build() {
    cd mbedtls-2.4.0/ && configure_success="$?"
    CC=$compiler LD=$compiler make |& tee kcc_make_out.txt ; make_success="$?"
    $compiler -d -Wall -W -Wdeclaration-after-statement -I../include -D_FILE_OFFSET_BITS=64 -O2 -c net_sockets.c |& tee kcc_out.txt
}

extract() {
    cd mbedtls-2.4.0/library/ && process_kcc_config
    cd mbedtls-2.4.0/ && mv kcc_* $log_dir
}

init
