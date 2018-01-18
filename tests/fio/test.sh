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
    CC=$compiler LD=$compiler ./configure --cc=$compiler |& tee kcc_configure_out.txt ; configure_success="$?"
    make |& tee kcc_make_out.txt ; make_success="$?"
}

_test() {
    :
}

init
