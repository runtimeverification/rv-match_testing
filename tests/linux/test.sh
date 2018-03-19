#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    :
}

_download() {
    git clone https://github.com/torvalds/linux.git
    cd linux/
    git checkout 4fbd8d194f06c8a3fd2af1ce560ddb31f7ec8323
}

_build() {
    cd linux/ ; results[0]="$?" ; postup 0
    make mrproper CC=$compiler LD=$compiler |& tee kcc_build_1.txt ; results[1]="$?" ; postup 1
}

init
