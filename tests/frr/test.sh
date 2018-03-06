#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    sudo apt -y install libjson-c-dev libpython-dev flex
}

_download() {
    frrdownloaddir=$(pwd)
    git clone https://github.com/FRRouting/frr.git
    cd frr/
    git checkout 41d19ab553a1c0a9c7c3c32b3e98f185e976f65e
    cd $frrdownloaddir
    git clone https://github.com/FRRouting/topotests.git
    cd topotests/
    git checkout a24f1765db1735c2901c286f9095aa7779c42bf3
}

_build() {
    # Note: non-trivial linking
    # https://github.com/FRRouting/frr/issues/1834
    cd frr/
    names[0]="bootstrap"  ; bash bootstrap.sh  |& tee kcc_build_0.txt ; results[0]="$?" ; process_kcc_config 0
    names[1]="configure"   ; ./configure CC=$compiler |& tee kcc_build_1.txt ; results[1]="$?" ; process_kcc_config 1
    names[2]="make"        ; make        |& tee kcc_build_2.txt ; results[2]="$?" ; process_kcc_config 2
}

_test() {
    :
}

init
