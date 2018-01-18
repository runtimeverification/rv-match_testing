#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_download() {
    git clone https://github.com/FFmpeg/FFmpeg.git
    cd FFmpeg/
    git checkout acf70639fb534a4ae9b1e4c76153f0faa0bda190
}

_build() {
    cd FFmpeg/
    set -o pipefail
    if [[ $compiler == "kcc" ]]; then
        ./configure --cc=kcc --ld=kcc --disable-stripping --disable-asm --disable-inline-asm --disable-x86asm --extra-cflags="-std=gnu11 -frecover-all-errors" |& tee kcc_configure_out.txt ; configure_success="$?"
    else
        ./configure --cc=$compiler --ld=$compiler --disable-stripping --disable-asm --disable-inline-asm --disable-x86asm |& tee kcc_configure_out.txt ; configure_success="$?"
    fi
    make examples |& tee kcc_make_out.txt ; make_success="$?"
}

init
