#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

#https://github.com/runtimeverification/rv-match/issues/590

_download() {
    git clone https://github.com/msotoodeh/curve25519.git
    cd curve25519/
    git checkout 85dcab1300ff1b196042839de9c8bbea26329537
}

_build() {
    cd curve25519/
    if [[ $compiler == "kcc" ]] ; then
        cppcompiler="k++"
        sed -i -e "s/GPP   = g++/GPP   = $cppcompiler/g" Rules.mk
        sed -i -e "s/LD    = ld/LD    = kcc/g" Rules.mk
        sed -i -e "s/CC    = gcc/CFLAGS += -std=gnu11 -frecover-all-errors\nCC    = kcc/g" Rules.mk |& tee kcc_build_0.txt ; results[0]="$?"
    else
        cppcompiler="g++"
        sed -i -e "s/GPP   = g++/GPP   = $cppcompiler/g" Rules.mk && sed -i -e "s/CC    = gcc/CC    = $compiler/g" Rules.mk |& tee kcc_build_0.txt ; results[0]="$?"
    fi
    make |& tee kcc_build_1.txt ; results[1]="$?"
}

init
