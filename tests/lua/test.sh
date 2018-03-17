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
    if [ "$compiler" == "kcc" ] || [ "$compiler" == "rvpc" ] ; then
        reportflag="CFLAGS=-fissue-report=$json_out"
    else
        reportflag=""
    fi
    names[0]="folder" ; cd lua-$VERSION/ && results[0]="$?" ; process_kcc_config 0
    names[1]="make linux" ; make linux CC=$compiler LD=$compiler $reportflag |& tee kcc_build_1.txt ; results[1]="$?" ; process_kcc_config 1
}

_test() {
    cd lua-$VERSION-tests/
    names[0]="lua all" ; $build_dir/lua-$VERSION/src/lua all.lua |& tee kcc_out_0.txt ; results[0]="$?" ; process_config 0
}

init
