#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh

_download() {
    git clone https://github.com/Tarsnap/scrypt.git
    cd scrypt/
    git checkout 4e4f88ad775fc2ea5e59f38e191ac6f5b3e375c7
    echo "Force redownload since hash was present somehow."
}

_build() {
    cd scrypt/
    autoscan
    aclocal ; autoheader ; autoreconf
    automake --add-missing
    autoreconf
    ./configure CC=$compiler LD=$compiler ; configure_success="$?"
    make ; make_success="$?"
}

_extract() {
    cd scrypt/ && process_kcc_config
    cd scrypt/ && cp kcc_* $log_dir
}

_test() {
    cd scrypt/
    names[0]="basic test"
    ./tests/test_scrypt ; results[0]="$?"
}

_extract_test() {
    cd scrypt/
    echo "Inside the _extract_test() function now."
}

init
