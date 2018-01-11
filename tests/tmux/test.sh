#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_download() {
    git clone https://github.com/tmux/tmux.git
    cd tmux/
    git checkout cf782c4f546fb11f3157de7aecff85845b0dbed9
}

_build() {
    cd tmux/
    CC=$compiler LD=$compiler bash autogen.sh
    ./configure CC=$compiler LD=$compiler |& tee kcc_configure_out.txt ; configure_success="$?"
    make |& tee kcc_make_out.txt ; make_success="$?"
}

init
