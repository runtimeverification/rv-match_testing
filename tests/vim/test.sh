#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh

_download() {
    git clone https://github.com/vim/vim
    cd vim/
    git checkout 23c1b2b018c8121ca5fcc247e37966428bf8ca66
}

_build() {
    cd vim/
    ./configure CC=$compiler LD=$compiler |& tee kcc_configure_out.txt ; configure_success="$?"
    make |& tee kcc_make_out.txt ; make_success="$?"
}

_export() {
    cd vim/ && process_kcc_config
    cd vim/ && cp kcc_* $log_dir
}

init
