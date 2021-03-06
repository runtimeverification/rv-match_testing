#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    sudo apt -y install ncurses-dev
    sudo apt -y install libncurses5-dev
    sudo apt -y install libncursesw5-dev
    sudo apt -y build-dep vim
}

_download() {
    git clone https://github.com/vim/vim
    cd vim/
    git checkout 23c1b2b018c8121ca5fcc247e37966428bf8ca66
}

_build() {
    cd vim/
    kcc -profile x86_64-linux-gcc-glibc
    ./configure CC=$compiler CFLAGS="-std=gnu11" LD=$compiler LDFLAGS="-ldl" LINK_AS_NEEDED="yes" |& tee rv_build_0.txt ; results[0]="$?" ; postup 0
    make -j`nproc` |& tee rv_build_1.txt ; results[1]="$?" ; postup 1
}

init
