#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    :
}

_download() {
    git clone https://github.com/BIRD/bird.git
    cd bird/
    git checkout d6cf996151307d083c30e4ecde0f1d7449b19253
}

_build() {
    ./configure |& tee kcc_build_0.txt ; results[0]="$?" ; process_kcc_config 0
}

_test() {
    :
}

init
