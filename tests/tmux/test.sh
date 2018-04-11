#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    sudo apt -y install libevent-dev
}

_download() {
    git clone https://github.com/tmux/tmux.git
    cd tmux/
    git checkout cf782c4f546fb11f3157de7aecff85845b0dbed9
}

_build() {
    cd tmux/
    bash autogen.sh
    if [[ $compiler == "kcc" ]]; then
        ./configure CC=kcc CFLAGS="-no-pedantic" LD=kcc |& tee rv_build_0.txt ; results[0]="$?"
    else
        ./configure CC=$compiler |& tee rv_build_0.txt ; results[0]="$?"
    fi
    postup 0

    make -j`nproc` |& tee rv_build_1.txt ; results[1]="$?" ; postup 1
}

init
