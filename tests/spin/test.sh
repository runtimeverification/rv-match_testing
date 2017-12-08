#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh
# http://spinroot.com/spin/whatispin.html

_download() {
    wget http://spinroot.com/spin/Src/spin647.tar.gz
    tar -xvzf spin647.tar.gz
    rm spin647.tar.gz
}

_build() {
    cd Spin/Src6.4.7
    sed -i -e "s/CC=gcc/CC=$compiler/g" makefile ; configure_success="$?"
    make ; make_success="$?"
}

_extract() {
    return
}

init
