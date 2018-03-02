#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_download() {
    git clone https://github.com/openssl/openssl.git
    cd openssl/
    git checkout d166ed8c11e10e9fdaeac182effb9dd318843924
}

_build() {
    cd openssl/
    set -o pipefail
    if [[ $compiler == "kcc" ]]; then
        CC="kcc -std=gnu11 -no-pedantic -frecover-all-errors" CXX=k++ LD=kcc ./config no-asm no-threads no-hw no-zlib no-shared |& tee kcc_build_0.txt ; results[0]="$?" ; process_kcc_config 0
    else
        CC=$compiler ./config no-asm no-threads no-hw no-zlib no-shared |& tee kcc_build_0.txt ; results[0]="$?" ; process_kcc_config 0
    fi
    make |& tee kcc_build_1.txt ; results[1]="$?" ; process_kcc_config 1
}

_test() {
    cd openssl/
    names[0]="md4test"
    ./test/md4test |& tee "kcc_out_0.txt" ; results[0]="$?"
    names[1]="md5test"
    ./test/md5test |& tee "kcc_out_1.txt" ; results[1]="$?"
}


init
