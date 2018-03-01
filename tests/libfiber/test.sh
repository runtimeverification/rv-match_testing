#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    :
}

_download() {
    git clone https://github.com/acl-dev/libfiber.git
    cd libfiber/
    git checkout ee97eb7d43dfc9dae1e2f70e5fe4d5dd201ee3ef
}

_build() {
    names[0]="make"
    cd libfiber/ ; sed -i -e "s/gcc/$compiler/g" Makefile
    CC=$compiler LD=$compiler make |& tee kcc_build_0.txt ; results[0]="$?" ; process_kcc_config 0
    names[1]="make samples"
    cd samples/  ; sed -i -e "s/gcc/$compiler/g" Makefile.in
    CC=$compiler LD=$compiler make |& tee kcc_build_1.txt ; results[1]="$?" ; process_kcc_config 1
}

_test() {
    :
}

init
