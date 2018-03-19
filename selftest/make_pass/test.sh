#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_download() {
    :
}

_build() {
    results[0]="0" ; postup 0
    results[1]="0" ; postup 1
}

_test() {
    :
}

init
