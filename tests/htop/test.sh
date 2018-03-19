#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    sudo apt -y install libncursesw5-dev
}

_download() {
    git clone https://github.com/hishamhm/htop.git
    cd htop/
    git checkout f37a050d3d0c6928b09d9b19e1283a695c52ccc7
}

_build() {
    cd htop/
    autoreconf
    automake --add-missing
    autoreconf
    ./configure CC=$compiler LD=$compiler |& tee kcc_build_0.txt ; results[0]="$?" ; postup 0
    make |& tee kcc_build_1.txt ; results[1]="$?" ; postup 1
}

_test() {
    :
}

init
