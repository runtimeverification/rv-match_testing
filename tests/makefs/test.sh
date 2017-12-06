#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh

_download() {
    git clone https://github.com/ssteuteville/makefs.git
    cd makefs/
    git checkout 574926f2eee9661c37909b0df3627fa000312ca1
}

_build() {
    cd makefs/src/
    sed -i -e "s/gcc/$compiler/g" Makefile ; configure_success="$?"
    make |& tee kcc_make_out.txt ; make_success="$?"
}

_export() {
    cd makefs/src/ && process_kcc_config
    cd makefs/src/ && mv kcc_* $log_dir
}

init
