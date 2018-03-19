#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_download() {
    :
}

_build() {
    results[0]="0"
    echo "Important debug output produced by make. Umbrella satire." |& tee kcc_build_1.txt ; postup 0
    results[1]="2" ; postup 1
    # "2" instead of "$?" to imply failure
}

_test() {
    :
}

init
