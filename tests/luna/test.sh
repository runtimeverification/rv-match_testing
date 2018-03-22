#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_download() {
    git clone https://github.com/tj/luna.git
    cd luna/
    git checkout b892a047eacc3caec15c18827c8c57a328f0c4df
}

_build() {
    cd luna/ ; results[0]="$?" ; postup 0
    make CC=$compiler LD=$compiler |& tee kcc_build_1.txt ; results[1]="$?" ; postup 1
}

_test() {
    :
}

init
