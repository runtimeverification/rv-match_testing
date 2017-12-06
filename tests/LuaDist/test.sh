#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh

_download() {
    git clone https://github.com/LuaDist/lua.git
    cd lua/
    git checkout d2e7e7d4d43ff9068b279a617c5b2ca2c2771676
}

_build() {
    cd lua/
    CC=$compiler LD=$compiler cmake . |& tee kcc_configure_out.txt ; configure_success="$?"
    CC=$compiler LD=$compiler make |& tee kcc_make_out.txt ; make_success="$?"
}

_export() {
    cd lua/ && process_kcc_config
    cd lua/ && mv kcc_* $log_dir
}

init
