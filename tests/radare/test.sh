#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_download() {
    git clone https://github.com/radare/radare2.git
    cd radare2/
    git checkout 6ba461f1c1c0e32fad16e2191676711da02865ad
}

_build() {
    cd radare2/
    ./configure CC=$compiler LD=$compiler |& tee rv_build_0.txt ; results[0]="$?" ; postup 0
    make -j`nproc` |& tee rv_build_1.txt ; results[1]="$?" ; postup 1
}

_test() {
    :
}

init
