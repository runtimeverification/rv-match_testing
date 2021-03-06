#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_download() {
    git clone https://github.com/libuv/libuv.git
    cd libuv/
    git checkout 719dfecf95b0c74af6494f05049e56d5771ebfae
}

_build() {
    cd libuv/
    bash autogen.sh
    set -o pipefail
    ./configure CC=$compiler LD=$compiler |& tee rv_build_0.txt ; results[0]="$?" ; postup 0
    make -j`nproc` |& tee rv_build_1.txt ; results[1]="$?" ; postup 1
}

init
