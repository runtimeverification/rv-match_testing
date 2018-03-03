#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    :
}

_download() {
#git clone git://sourceware.org/git/binutils-gdb.git
#https://www.gnu.org/software/binutils/
#https://github.com/gittup/binutils
    git clone https://github.com/gittup/binutils.git
    cd binutils/
    git checkout 8db2e9c8d085222ac7b57272ee263733ae193565
}

_build() {
    cd binutils/
    ./configure CC=$compiler LD=$compiler |& tee kcc_build_0.txt ; results[0]="$?" ; process_kcc_config 0
           make CC=$compiler LD=$compiler |& tee kcc_build_1.txt ; results[1]="$?" ; process_kcc_config 1
}

_test() {
    :
}

init
