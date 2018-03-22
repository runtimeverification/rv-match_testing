#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_download() {
    git clone https://github.com/mstegen/Open-Chargeport.git
    cd Open-Chargeport/
    git checkout 4fdffded66910fe04250e5dc19f3d89ede9bd17c
}

_build() {
    return
    |& tee kcc_build_0.txt ; results[0]="$?" ; postup 0
    |& tee kcc_build_1.txt ; results[1]="$?" ; postup 1
}

init

