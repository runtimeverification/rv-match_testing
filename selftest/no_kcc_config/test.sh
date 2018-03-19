#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_download() {
    mkdir directory_one/
    mkdir directory_two/
    mkdir directory_one/sub_directory_one_A/
    mkdir directory_one/sub_directory_one_B/
}

_build() {
    results[0]="0" ; postup 0
    results[1]="2" ; postup 1
}

_test() {
    :
}

init
