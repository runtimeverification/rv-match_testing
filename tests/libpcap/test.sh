#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    sudo apt -y install bison
    sudo apt -y install flex
}

_download() {
    git clone https://github.com/the-tcpdump-group/libpcap.git
    cd libpcap/
    git checkout 3b67275e19d04d493bb2dfc4050332fb27217b95
}

_build() {
    cd libpcap/
    aclocal; autoreconf
    ./configure CC="$compiler -std=gnu11" LD=$compiler |& tee kcc_build_0.txt ; results[0]="$?" ; process_kcc_config 0
    make |& tee kcc_build_1.txt ; results[1]="$?" ; process_kcc_config 1
}

_test() {
    :
}

init
