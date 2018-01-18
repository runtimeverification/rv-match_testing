#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_download() {
    git clone https://github.com/uber/h3.git
    cd h3/
    git checkout 8b02a95cd93530cb83ea3bd84a3d60c0cad6c9cd
}

_build() {
    cd h3/
    CC=$compiler LD=$compiler cmake . |& tee kcc_configure_out.txt ; configure_success="$?"
    make |& tee kcc_make_out.txt ; make_success="$?"
}

_test() {
    :
}

init
