#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    sudo apt -y install yasm
}

_download() {
    git clone https://github.com/FFmpeg/FFmpeg.git
    cd FFmpeg/
    git checkout acf70639fb534a4ae9b1e4c76153f0faa0bda190
}

_build() {
    cd FFmpeg/
    set -o pipefail
    if [[ $compiler == "kcc" ]]; then
        ./configure --cc=kcc --ld=kcc --disable-stripping --disable-asm --disable-inline-asm --disable-x86asm --extra-cflags="-std=gnu11 -frecover-all-errors" |& tee kcc_build_0.txt ; results[0]="$?" ; process_kcc_config 0
    else
        ./configure --cc=$compiler --disable-stripping --disable-asm --disable-inline-asm --disable-x86asm |& tee kcc_build_0.txt ; results[0]="$?" ; process_kcc_config 0
    fi
    bash $base_dir/timeout.sh -t 30000 make examples |& tee kcc_build_1.txt ; results[1]="$?" ; process_kcc_config 1
}

init
