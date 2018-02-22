#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_download() {
    git clone https://github.com/Celtoys/Remotery.git
    cd Remotery/
    git checkout 4070513159ff3a72f12a47a249ce0e51abf19c34
}

_build() {
    cd Remotery/ ; results[0]="$?"
    kcc -profile x86_64-linux-gcc-glibc-gnuc
    $compiler -std=gnu11 lib/Remotery.c sample/sample.c -I lib -pthread -lm |& tee kcc_build_1.txt ; results[1]="$?"
    kcc -profile x86_64-linux-gcc-glibc
}

init
