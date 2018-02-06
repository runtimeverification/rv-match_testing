#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"
VERSION=5.3.4

_dependencies() {
    sudo apt -y install libreadline-dev
}

_download() {
    # For building
    tar=lua-$VERSION.tar.gz
    wget http://www.lua.org/ftp/$tar
    tar -xvzf $tar
    rm $tar
    
    # For testing
    tar_tests=lua-$VERSION-tests.tar.gz
    wget https://www.lua.org/tests/$tar_tests
    tar -xvzf $tar_tests
    rm $tar_tests
}

_build() {
    cd lua-$VERSION/ && configure_success="$?"
    make linux CC=$compiler LD=$compiler |& tee kcc_make_out.txt ; make_success="$?"
}

_test() {
    cd lua-$VERSION-tests/
    $build_dir/lua-$VERSION/src/lua all.lua |& tee kcc_runtime.txt ; test_success="$?"
}

init
