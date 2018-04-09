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
    sed -i '124,125d' tests/Makefile.in
    aclocal; autoreconf
    ./configure CC="$compiler -std=gnu11" LD=$compiler |& tee rv_build_0.txt ; results[0]="$?" ; postup 0
    make -j 8 |& tee rv_build_1.txt ; results[1]="$?" ; postup 1
    sed -i '35,38d' tests/CMakeLists.txt
    sed -i '82d' tests/Makefile
    sed -i -e "s/valgrindtest.c/capturetest.c/g" tests/Makefile
    cd tests/
    names[2]="make tests" ; make -j 8 |& tee rv_build_2.txt ; results[2]="$?" ; postup 2
}

_test() {
    :
}

init
