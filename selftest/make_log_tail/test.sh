#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_download() {
    :
}

_build() {
    configure_success="0"
    echo "Important debug output produced by make. Umbrella satire." |& tee kcc_make_out.txt
    make_success="2" # instead of "$?" to imply failure
}

_test() {
    :
}

init
