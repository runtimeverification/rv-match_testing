#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    sudo apt -y install zlib1g-dev
    sudo apt -y install uuid-dev
}

_download() {
    git clone https://github.com/firehol/netdata.git
    cd netdata/
    git checkout 2bbde1ba150b0d6fb66cd01d94b26da0181fd45e
}

_build() {
    cd netdata/
    autoscan
    aclocal
    autoheader
    autoreconf
    automake --add-missing
    autoreconf
    set -o pipefail
    if [[ $compiler == "kcc" ]]; then
        ./configure CC=kcc CFLAGS="-std=gnu11 -frecover-all-errors -no-pedantic" LD=kcc |& tee rv_build_0.txt ; results[0]="$?" ; postup 0
    else
        ./configure CC=$compiler |& tee rv_build_0.txt ; results[0]="$?" ; postup 0
    fi
    make -j 8 |& tee rv_build_1.txt ; results[1]="$?" ; postup 1
}

init
