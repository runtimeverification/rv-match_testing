#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_download() {
    # https://github.com/runtimeverification/toyota-itc-benchmarks
    # https://github.com/regehr/itc-benchmarks
    # https://github.com/Toyota-ITC-SSD/Software-Analysis-Benchmark
    git clone https://github.com/Toyota-ITC-SSD/Software-Analysis-Benchmark.git
    cd Software-Analysis-Benchmark/
    git checkout c146ccab82e401b2dfeef85b8e1e9368ae5dd8fd
}

_build() {
    # warning: not assigning LD to see if it fixes bit_shift.c:237:9: error: ‘sink’ undeclared
    cd Software-Analysis-Benchmark/
    names[0]="autoreconf" ; autoreconf -i |& tee rv_build_0.txt ; results[0]="$?" ; postup 0
    names[1]="configure"  ; ./configure CC=$compiler |& tee rv_build_1.txt ; results[1]="$?" ; postup 1
    names[2]="make"       ; make -j`nproc` |& tee rv_build_2.txt ; results[2]="$?" ; postup 2
}

_test() {
    :
}

init
