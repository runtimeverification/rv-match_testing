#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_download() {
    git clone https://github.com/vim/vim
    cd vim/
    git checkout 23c1b2b018c8121ca5fcc247e37966428bf8ca66
}

_build() {
    cd vim/
    kcc -profile x86_64-linux-gcc-glibc
    ./configure CC=$compiler CFLAGS="-std=gnu11" LD=$compiler LDFLAGS="-ldl" |& tee kcc_configure_out.txt ; configure_success="$?"
    make |& tee kcc_make_out.txt ; make_success="$?"
}

init
