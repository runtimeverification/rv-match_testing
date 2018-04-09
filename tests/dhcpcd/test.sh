#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_download() {
    git clone https://github.com/rsmarples/dhcpcd.git
    cd dhcpcd/
    git checkout 7a3669251dca114f259e6c140a315e4e85fbd10f
}

_build() {
    cd dhcpcd/
    if [[ $compiler == "kcc" ]]; then
        kcc -profile x86_64-linux-gcc-glibc
        ./configure CC=kcc CFLAGS="-D__packed='__attribute__((packed))' -frecover-all-errors -fissue-report=$json_out" LD=kcc |& tee rv_build_0.txt ; results[0]="$?" ; postup 0
    else
        ./configure CC=$compiler |& tee rv_build_0.txt ; results[0]="$?" ; postup 0
    fi
    set -o pipefail
    make -j 8 |& tee rv_build_1.txt
    [ -f src/dhcpcd ] ; results[1]="$?" ; postup 1

    cd tests/ ; names[2]="make tests" ; CC=$compiler LD=$compiler make -j 8 |& tee rv_build_2.txt ; results[2]="$?" ; postup 2
    
}

_test() {
    begindhcpcdtestdir=$(pwd)
    cd $begindhcpcdtestdir/dhcpcd/tests/crypt/
    names[0]="crypt" ; ./run-test |& tee rv_out_0.txt ; results[0]="$?" ; process_config 0
    
    cd $begindhcpcdtestdir/dhcpcd/tests/eloop-bench/
    names[1]="eloop-bench" ; ./eloop-bench |& tee rv_out_1.txt ; results[1]="$?" ; process_config 1
}

init
