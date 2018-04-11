#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    sudo apt -y install libevent-dev
    sudo apt -y install bison
    sudo apt -y install flex
}

_download() {
    git clone https://github.com/NLnetLabs/nsd.git
    cd nsd/
    git checkout ee44df629568c7d01842cc8c56de1840825bf211
}

_build() {
    # Tim's bug report:
    # https://nlnetlabs.nl/bugs-script/show_bug.cgi?id=3562
    cd nsd/
    names[0]="autoreconf" ; autoreconf  |& tee rv_build_0.txt ; results[0]="$?" ; postup 0
    names[1]="configure"  ; ./configure CC=$compiler LD=$compiler |& tee rv_build_1.txt ; results[1]="$?" ; postup 1
    names[2]="make"       ; make -j`nproc`   |& tee rv_build_2.txt ; results[2]="$?" ; postup 2
}

_test() {
    :
}

init
