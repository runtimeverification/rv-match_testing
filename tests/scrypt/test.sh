#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    sudo apt -y install libssl-dev
}

_download() {
    git clone https://github.com/Tarsnap/scrypt.git
    cd scrypt/
    git checkout 4e4f88ad775fc2ea5e59f38e191ac6f5b3e375c7
}

_build() {
    cd scrypt/
    autoscan
    aclocal ; autoheader ; autoreconf
    automake --add-missing
    autoreconf
    ./configure CC=$compiler LD=$compiler |& tee rv_build_0.txt ; results[0]="$?" ; postup 0
    make -j`nproc` |& tee rv_build_1.txt ; results[1]="$?" ; postup 1
}

_test() {
    cd scrypt/
    names[0]="basic test"
    ./tests/test_scrypt |& tee rv_out_0.txt ; results[0]="$?" ; process_config 0
}

init
