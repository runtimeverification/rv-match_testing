#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    sudo apt -y install libdb++-dev
}

_download() {
    git clone https://github.com/vergecurrency/VERGE
    cd VERGE/
    git checkout 1c418be3bf0fe751799052df768eb5784e3b400b
}

_build() {
    cd VERGE/
    names[0]="autogen script" ; bash autogen.sh |& tee rv_build_0.txt ; results[0]="$?" ; postup 0
    names[1]="configure"      ; ./configure CC=$compiler LD=$compiler |& tee rv_build_1.txt ; results[1]="$?" ; postup 1
    names[2]="make"           ; make -j 8       |& tee rv_build_2.txt ; results[2]="$?" ; postup 2
}

_test() {
    :
}

init
