#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    sudo apt -y install libssl-dev
}

_download() {
    git clone https://github.com/curl/curl.git
    cd curl/
    git checkout 00cda0f9b31e45512776670201f9ec2eec095338
}

_build() {
    cd curl/
    moreflags='-fprofile-arcs -ftest-coverage -g -O0'
    if [[ $compiler == "kcc" ]]; then
        CC=kcc CFLAGS="-std=gnu11 -no-pedantic -frecover-all-errors $moreflags" LD=kcc cmake -DCURL_STATICLIB=ON . |& tee rv_build_0.txt ; results[0]="$?" ; postup 0
    else
        CC=$compiler CFLAGS="$moreflags" cmake -DCURL_STATICLIB=ON . |& tee rv_build_0.txt ; results[0]="$?" ; postup 0
    fi
    make |& tee rv_build_1.txt ; results[1]="$?" ; postup 1

    # Leave the passing regression test alone.
    if [ "$exportfile" == "regression" ] ; then return ; fi

    names[2]="make tests"
    make tests |& tee rv_build_2.txt ; results[2]="$?" ; postup 2
    names[3]="make test-torture"
    make test-torture |& tee rv_build_3.txt ; results[3]="$?" ; postup 3
}

_test() {
    cd curl/tests/
    names[0]="test 1" ; ./runtests.pl 1 |& tee rv_out_0.txt ; results[0]="$?" ; process_config 0
    names[1]="test 2" ; ./runtests.pl 2 |& tee rv_out_1.txt ; results[1]="$?" ; process_config 1
    names[2]="test 3" ; ./runtests.pl 3 |& tee rv_out_2.txt ; results[2]="$?" ; process_config 2
}

init
