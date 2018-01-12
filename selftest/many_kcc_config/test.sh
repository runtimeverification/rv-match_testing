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
    touch directory_two/kcc_config
    touch directory_one/sub_directory_one_B/kcc_config
    configure_success="0"
    make_success="2"
}

_test() {
    :
}

init
