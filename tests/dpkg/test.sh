#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_download() {
    git clone git://anonscm.debian.org/dpkg/dpkg.git
    cd dpkg/
    git checkout b9798daaa596ad5d539bcdd5ca89de1cb0b81697
}

_build() {
    cd dpkg/
    autoscan
    aclocal
    autoheader
    autoreconf
    automake --add-missing
    autoreconf -vif
    if [[ $compiler == "kcc" ]]; then
        ./configure CC=kcc LD=kcc LDFLAGS="-lz" |& tee kcc_configure_out.txt ; configure_success="$?"
    else
        ./configure CC=$compiler |& tee kcc_configure_out.txt ; configure_success="$?"
    fi
    make |& tee kcc_make_out.txt ; make_success="$?"
    cd dpkg-split
}

init
