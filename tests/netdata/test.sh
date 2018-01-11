#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

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
    ./configure CC=$compiler LD=$compiler |& tee kcc_configure_out.txt ; configure_success="$?"
    make |& tee kcc_make_out.txt ; make_success="$?"
    cd ./src/
    kcc -d -g -pthread -o apps.plugin apps_plugin.o avl.o clocks.o common.o log.o procfile.o web_buffer.o -lm |& tee kcc_out.txt
}

init
