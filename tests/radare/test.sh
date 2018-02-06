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
    ./configure CC=$compiler LD=$compiler |& tee kcc_configure_out.txt ; configure_success="$?"
    make |& tee kcc_make_out.txt ; make_success="$?"
}

_test() {
    return
}

init
