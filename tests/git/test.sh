#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_download() {
    git clone https://github.com/git/git.git
    cd git/
    git checkout 2512f15446149235156528dafbe75930c712b29e
}

_build() {
    cd git/ ; configure_success="$?"
    make CC=$compiler LD=$compiler ; make_success="$?"
}

_test() {
    :
}

init
