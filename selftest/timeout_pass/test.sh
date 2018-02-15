#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_download() {
    :
}

_build() {
    [ : ] |& tee kcc_configure_out.txt ; configure_success="$?"
    bash $base_dir/timeout.sh -t 1 [ : ] |& tee kcc_make_out.txt ; make_success="$?"
}

_test() {
    :
}

init
