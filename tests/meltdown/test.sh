#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_download() {
    git clone https://github.com/IAIK/meltdown.git
    cd meltdown/
    git checkout 93418ba288e909e89986964969079db4e318cfaa
}

_build() {
    cd meltdown/ ; configure_success="$?"
    make CC=$compiler LD=$compiler ; make_success="$?"
}

_test() {
    :
}

init
