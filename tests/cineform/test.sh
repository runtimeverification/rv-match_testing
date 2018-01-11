#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh

_download() {
    git clone https://github.com/gopro/cineform-sdk.git
    cd cineform-sdk/
    git checkout 81c9eb118a4f2a03a3194098623f0cbfd85f3561
}

_build() {
    cd cineform-sdk/
    CC=$compiler LD=$compiler cmake . |& tee kcc_configure_out.txt ; configure_success="$?"
    make |& tee kcc_make_out.txt ; make_success="$?"
}

init
