#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh

_download() {
    git clone https://github.com/curl/curl.git
    cd curl/
    git checkout 00cda0f9b31e45512776670201f9ec2eec095338
}

_build() {
    cd curl/
    #Try "kcc -d" in place of "kcc" to get more information
    CC=$compiler LD=$compiler cmake . |& tee kcc_configure_out.txt ; configure_success="$?"
    make |& tee kcc_make_out.txt ; make_success="$?"
}

_export() {
    cd curl/lib/ && process_kcc_config
    cd curl/ && mv kcc_* $log_dir
}

init
