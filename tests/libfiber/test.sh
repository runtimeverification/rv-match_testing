#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    sudo apt -y install valgrind
}

_download() {
    git clone https://github.com/acl-dev/libfiber.git
    cd libfiber/
    git checkout ee97eb7d43dfc9dae1e2f70e5fe4d5dd201ee3ef
}

_build() {
    names[0]="make"
    cd libfiber/ ; sed -i -e "s/gcc/$compiler/g" Makefile
    CC=$compiler LD=$compiler make -j`nproc` |& tee rv_build_0.txt ; results[0]="$?" ; postup 0
    names[1]="make samples"
    cd samples/  ; sed -i -e "s/gcc/$compiler/g" Makefile.in
    CC=$compiler LD=$compiler make -j`nproc` |& tee rv_build_1.txt ; results[1]="$?" ; postup 1
}

_test() {
    cd libfiber/samples/server/
    ./server &
    PID=$!
    cd ../client/
    names[0]="client return code" ; ./client |& tee rv_out_0.txt ; results[0]="$?" ; process_config 0
    kill $PID
}

init
