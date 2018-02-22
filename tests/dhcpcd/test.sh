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
        ./configure CC=kcc CFLAGS="-D__packed='__attribute__((packed))' -frecover-all-errors" LD=kcc |& tee kcc_build_0.txt ; results[0]="$?"
    else
        ./configure CC=$compiler |& tee kcc_build_0.txt ; results[0]="$?"
    fi
    set -o pipefail
    make |& tee kcc_build_1.txt
    [ -f src/dhcpcd ] ; results[1]="$?"
}

init
