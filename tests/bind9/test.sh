#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_download() {
    git clone https://source.isc.org/git/bind9.git
    cd bind9/
    git checkout 63270d33f1103f6193aebd6c205b78064b4cdfe5
}

_build() {
    cd bind9/
    autoreconf
    set -o pipefail
    if [[ $compiler == "kcc" ]]; then
        ./configure CC=kcc CFLAGS="-std=gnu11 -no-pedantic -frecover-all-errors" LD=kcc |& tee kcc_configure_out.txt ; configure_success="$?"
    else
        ./configure CC=$compiler |& tee kcc_configure_out.txt ; configure_success="$?"
    fi
    make |& tee kcc_make_out.txt ; make_success="$?"
}

init
