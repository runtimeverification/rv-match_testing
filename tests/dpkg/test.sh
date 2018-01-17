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
    echo "DPKG DEBUG"
    sed '5133q;d' configure
    ./configure CC=$compiler LD=$compiler |& tee kcc_configure_out.txt ; configure_success="$?"
    make |& tee kcc_make_out.txt ; make_success="$?"
    cd dpkg-split
    $compiler -d -g -O1 -o dpkg-split info.o join.o main.o queue.o split.o ../lib/dpkg/.libs/libdpkg.a |& tee kcc_out.txt
}

init
