#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_download() {
    git clone https://github.com/gwsystems/ps.git
    cd ps/
    git checkout 1622d2fb1e8331fdc2724787960ce956070d4ab3
}

_build() {
    cd ps/
    ./configure linux x86_64 |& tee kcc_build_0.txt ; results[0]="$?"
    make CC=$compiler LD=$compiler |& tee kcc_build_1.txt ; results[1]="$?"
}

_test() {
    :
}

init
