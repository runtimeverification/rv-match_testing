#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh

_download() {
    wget http://ftp.gnu.org/gnu/coreutils/coreutils-8.28.tar.xz
    tar xf coreutils-8.28.tar.xz
    cd coreutils-8.28/
}

_build() {
    cd coreutils-8.28/
    autoreconf
    ./configure CC=$compiler LD=$compiler --disable-threads |& tee kcc_configure_out.txt ; configure_success="$?"
    make |& tee kcc_make_out.txt ; make_success="$?"
    $compiler -d -I. -I./lib -Ilib -I./lib -Isrc -I./src -g -MT lib/parse-datetime.o -MD -MP -MF lib/.deps/parse-datetime.Tpo -c -o lib/parse-datetime.o lib/parse-datetime.c |& tee kcc_out.txt
}

_extract() {
    cd coreutils-8.28/ && process_kcc_config
    cd coreutils-8.28/ && cp kcc_* $log_dir
}

init
