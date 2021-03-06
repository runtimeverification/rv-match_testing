#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_download() {
    git clone https://github.com/pjreddie/darknet.git
    cd darknet/
    git checkout 80d9bec20f0a44ab07616215c6eadb2d633492fe
}

_build() {
    cd darknet/ && sed -i -e "s/gcc/$compiler/g" Makefile ; results[0]="$?" ; postup 0
    make -j`nproc` |& tee rv_build_1.txt ; results[1]="$?" ; postup 1
}

_test() {
    :
}

init
