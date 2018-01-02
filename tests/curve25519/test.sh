#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh

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
        echo !!!!!!!!!!!!!!!!!!! should replace
    else
        cppcompiler="g++"
        echo !!!!!!!!!!!!!!!!!!! should not replace
    fi
    sed -i -e "s/GPP   = g++/GPP   = $cppcompiler/g" Rules.mk && sed -i -e "s/CC    = gcc/CC    = $compiler/g" Rules.mk ; configure_success="$?"
    make CC=$compiler LD=$compiler ; make_success="$?"
}

_extract() {
    return
}

init
