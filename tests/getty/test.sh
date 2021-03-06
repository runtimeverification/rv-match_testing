#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    :
}

_download() {
    git clone https://github.com/StarchLinux/getty.git
    cd getty/
    git checkout a6c24ec43804588a3c35c9ed3325ed3086ddd056
}

_build() {
    cd getty/ ; results[0]="$?" ; postup 0
    sed -i "/strip/d" Makefile
    make -j`nproc` CC=$compiler LD=$compiler |& tee rv_build_1.txt ; results[1]="$?" ; postup 1
}

init
