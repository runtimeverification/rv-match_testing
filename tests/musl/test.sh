#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_download() {
    git clone https://github.com/bminor/musl.git
    cd musl/
    git checkout 4000b0107ddd7fe733fa31d4f078c6fcd35851d6
}

_build() {
    cd musl/
    ./configure --target=x86_64-linux-gnu CC=$compiler LD=$compiler |& tee kcc_build_0.txt ; results[0]="$?" ; process_kcc_config 0
    make |& tee kcc_build_1.txt ; results[1]="$?" ; process_kcc_config 1
}

init
