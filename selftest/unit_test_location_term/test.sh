#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_download() {
    :
}

_build() {
    results[0]="0" ; process_kcc_config 0
    results[1]="0" ; process_kcc_config 1
}

_test() {
    names[0]="test1"
    results[0]="1"
    touch config
    echo "pre location term sample <curr-program-loc> post location term sample" >> config
    process_config
}

init
