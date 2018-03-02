#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    sudo apt -y install openssl
    sudo apt -y install libssl-dev
}

_download() {
    git clone https://source.isc.org/git/bind9.git
    cd bind9/
    git checkout 63270d33f1103f6193aebd6c205b78064b4cdfe5
}

_build() {
    cd bind9/
    names[0]="autoreconf"
    autoreconf |& tee kcc_build_0.txt ; results[0]="$?" ; process_kcc_config 0
    set -o pipefail

    names[1]="configure success"
    if [[ "$compiler" == "kcc" ]] ; then
        ./configure CC=$compiler CFLAGS="-std=gnu11 -no-pedantic -frecover-all-errors" LD=kcc --disable-threads --disable-atomic --disable-shared |& tee kcc_build_1.txt ; results[1]="$?"
    else
        if [[ "$compiler" == "rvpc" ]] ; then
            ./configure CC=$compiler |& tee kcc_build_1.txt ; results[1]="$?"
        else
            ./configure CC=$compiler --disable-threads --disable-atomic --disable-shared |& tee kcc_build_1.txt ; results[1]="$?"
        fi
    fi
    process_kcc_config 1

    names[2]="compile gen with gcc"
    gcc -Ilib/isc/include -o lib/dns/gen lib/dns/gen.c |& tee -a kcc_build_2.txt ; results[2]="$?" ; process_kcc_config 2

    #names[3]="set ulimit"
    #ulimit -s 16777216 |& tee -a kcc_build_3.txt ; results[3]="$?" ; process_kcc_config 3

    names[3]="make success"
    ulimit -s 16777216
    make |& tee kcc_build_3.txt ; results[3]="$?" ; process_kcc_config 3
}

_test() {
    cd bind9/
    names[0]="make unit"
    make unit |& tee kcc_out_0.txt ; results[0]="$?" ; process_config 0
}

init
