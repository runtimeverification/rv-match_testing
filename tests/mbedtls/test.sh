#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_download() {
    wget https://tls.mbed.org/download/mbedtls-2.4.0-gpl.tgz
    tar -zxvf mbedtls-2.4.0-gpl.tgz
    rm mbedtls-2.4.0-gpl.tgz
}

_build() {
    cd mbedtls-2.4.0/ && results[0]="$?" ; process_kcc_config 0
    if [[ $compiler == "kcc" ]]; then
        CC=kcc CFLAGS="-std=gnu11 -frecover-all-errors -no-pedantic" LD=kcc make |& tee kcc_build_1.txt ; results[1]="$?" ; process_kcc_config 1
    else
        CC=$compiler make |& tee kcc_build_1.txt ; results[1]="$?" ; process_kcc_config 1
    fi
}

init
