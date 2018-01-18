#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_download() {
    #sudo apt build-dep mawk
    echo "MAWK DEBUG _FORCE3 DL"
    apt-get source mawk
    rm mawk_1.3.3-17ubuntu2.diff.gz
    rm mawk_1.3.3-17ubuntu2.dsc
    rm mawk_1.3.3.orig.tar.gz
    cd mawk-1.3.3/
}

_build() {
    cd mawk-1.3.3/
    if [[ $compiler == "kcc" ]]; then
        ./configure CC=kcc LD=kcc |& tee kcc_configure_out.txt ; configure_success="$?"
    else
        ./configure CC=$compiler |& tee kcc_configure_out.txt ; configure_success="$?"
    fi
    make |& tee kcc_make_out.txt ; make_success="$?"
}

init
