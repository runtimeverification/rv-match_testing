#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_download() {
    git clone https://github.com/wg/wrk.git
    cd wrk/
    git checkout 91655b5520b524fc0b802ad12220c9dcd546757e
}

_build() {
    cd wrk/ ; configure_success="$?"
    make CC=$compiler LD=$compiler ; make_success="$?"
}

_test() {
    :
}

init
