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
    if [[ $compiler == "kcc" ]]; then
        ./configure --cc=kcc --ld=kcc --disable-stripping --disable-asm --disable-inline-asm --disable-x86asm --extra-cflags="-std=gnu11 -frecover-all-errors" |& tee rv_build_0.txt ; results[0]="$?" ; postup 0
    else
        ./configure --cc=$compiler --disable-stripping --disable-asm --disable-inline-asm --disable-x86asm |& tee rv_build_0.txt ; results[0]="$?" ; postup 0
    fi
    bash $base_dir/timeout.sh -t 30000 make -j`nproc` |& tee rv_build_1.txt ; results[1]="$?" ; postup 1
    names[2]="make examples"
    bash $base_dir/timeout.sh -t 30000 make -j`nproc` examples |& tee rv_build_2.txt ; results[2]="$?" ; postup 2
}

init
