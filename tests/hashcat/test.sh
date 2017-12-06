#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh

_download() {
    git clone https://github.com/hashcat/hashcat.git
    cd hashcat/
    git checkout f2ce04e9121bf19d82ac1c5d484fdc444d3b78db
}

_build() {
    cd hashcat/
    git submodule update --init
    sed -i -e "s/gcc/$compiler/g" ./src/Makefile ; configure_success="$?"
    make ; make_success="$?"
}

_extract() {
    cd hashcat/ && process_kcc_config
    cd hashcat/ && mv kcc_* $log_dir
}

init
