#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    :
}

_download() {
    frrdownloaddir=$(pwd)
    git clone https://github.com/FRRouting/frr.git
    cd frr/
    git checkout 6768912110483ced636141838f9e040715dece8f
    cd $frrdownloaddir
    git clone https://github.com/FRRouting/topotests.git
    cd topotests/
    git checkout a24f1765db1735c2901c286f9095aa7779c42bf3
}

_build() {
    ./configure |& tee kcc_build_0.txt ; results[0]="$?" ; process_kcc_config 0
}

_test() {
    :
}

init
