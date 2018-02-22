#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_download() {
    git clone https://github.com/openssl/openssl.git
    cd openssl/
    git checkout 7a908204ed3afe1379151c6d090148edb2fcc87e
    echo "oissdnfvd"
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

init
