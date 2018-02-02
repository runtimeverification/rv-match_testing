#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_download() {
    git clone https://github.com/Toyota-ITC-SSD/Software-Analysis-Benchmark.git
    cd Software-Analysis-Benchmark/
    git checkout c146ccab82e401b2dfeef85b8e1e9368ae5dd8fd
}

_build() {
    cd Software-Analysis-Benchmark/
    autoreconf
    automake --add-missing --force-missing
    autoreconf
    ./configure CC=$compiler LD=$compiler ; configure_success="$?"
    make ; make_success="$?"
}

_test() {
    return
}

init
