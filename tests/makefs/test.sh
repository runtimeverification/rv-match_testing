#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    sudo apt -y install fuse
    sudo apt -y install libfuse-dev
}

_download() {
    git clone https://github.com/ssteuteville/makefs.git
    cd makefs/
    git checkout 574926f2eee9661c37909b0df3627fa000312ca1
}

_build() {
    cd makefs/src/
    sed -i -e "s/gcc/$compiler/g" Makefile ; results[0]="$?" ; postup 0
    make -j 8 |& tee rv_build_1.txt ; results[1]="$?" ; postup 1
}

init
