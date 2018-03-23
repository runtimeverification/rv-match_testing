#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_download() {
    git clone https://github.com/axboe/fio.git
    cd fio/
    git checkout ca65714c48bcd4fc601e3c04163e2422352be9ca
}

_build() {
    cd fio/
    CC=$compiler LD=$compiler ./configure --cc=$compiler |& tee rv_build_0.txt ; results[0]="$?" ; postup 0
    make |& tee rv_build_1.txt ; results[1]="$?" ; postup 1
}

_test() {
    :
}

init
