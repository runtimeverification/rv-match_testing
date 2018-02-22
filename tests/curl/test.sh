#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    sudo apt -y install libssl-dev
}

_download() {
    git clone https://github.com/curl/curl.git
    cd curl/
    git checkout 00cda0f9b31e45512776670201f9ec2eec095338
}

_build() {
    cd curl/
    if [[ $compiler == "kcc" ]]; then
        CC=kcc CFLAGS="-std=gnu11 -no-pedantic -frecover-all-errors" LD=kcc cmake -DCURL_STATICLIB=ON . |& tee kcc_build_0.txt ; results[0]="$?"
    else
        CC=$compiler cmake -DCURL_STATICLIB=ON . |& tee kcc_build_0.txt ; results[0]="$?"
    fi
    make |& tee kcc_build_1.txt ; results[1]="$?"
}

init
