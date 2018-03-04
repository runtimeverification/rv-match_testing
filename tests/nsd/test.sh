#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    sudo apt -y install libevent-dev
    sudo apt -y install bison
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
    names[0]="autoreconf" ; autoreconf  |& tee kcc_build_0.txt ; results[0]="$?" ; process_kcc_config 0
    names[1]="configure"  ; ./configure |& tee kcc_build_1.txt ; results[1]="$?" ; process_kcc_config 1
    names[2]="make"       ; make        |& tee kcc_build_2.txt ; results[2]="$?" ; process_kcc_config 2
}

_test() {
    :
}

init
