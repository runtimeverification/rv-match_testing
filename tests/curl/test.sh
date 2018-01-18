#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_download() {
    git clone https://github.com/curl/curl.git
    cd curl/
    git checkout 00cda0f9b31e45512776670201f9ec2eec095338
}

_build() {
    cd curl/
    if [[ $compiler == "kcc" ]]; then
        CC=kcc CFLAGS="-std=gnu11 -no-pedantic -frecover-all-errors" LD=kcc cmake -DCURL_STATICLIB=ON . |& tee kcc_configure_out.txt ; configure_success="$?"
    else
        CC=$compiler cmake -DCURL_STATICLIB=ON . |& tee kcc_configure_out.txt ; configure_success="$?"
    fi
    make |& tee kcc_make_out.txt ; make_success="$?"
}

init
