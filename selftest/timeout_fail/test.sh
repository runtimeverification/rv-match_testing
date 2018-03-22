#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_download() {
    :
}

_build() {
    [ : ] |& tee kcc_build_0.txt ; results[0]="$?" ; postup 0
    bash $base_dir/timeout.sh -i 1 -d 1 -t 0 sleep 2 |& tee kcc_build_1.txt ; results[1]="$?" ; postup 1
}

_test() {
    :
}

init
