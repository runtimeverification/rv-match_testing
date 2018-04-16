#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    sudo apt -y install libssl-dev
}

_download() {
    wget https://curl.haxx.se/download/curl-7.59.0.tar.gz
    tar -xzf curl-7.59.0.tar.gz
}

_build() {
    cd curl-7.59.0/
    #moreflags='-fprofile-arcs -ftest-coverage -g -O0'
    #if [[ $compiler == "kcc" ]]; then
    #    CC=kcc CFLAGS="-std=gnu11 -no-pedantic -frecover-all-errors $moreflags" LD=kcc cmake -DCURL_STATICLIB=ON . |& tee rv_build_0.txt ; results[0]="$?" ; postup 0
    #else
    #    CC=$compiler CFLAGS="$moreflags" cmake -DCURL_STATICLIB=ON . |& tee rv_build_0.txt ; results[0]="$?" ; postup 0
    #fi
    #make |& tee rv_build_1.txt ; results[1]="$?" ; postup 1

    # Leave the passing regression test alone.
    #if [ "$exportfile" == "regression" ] ; then return ; fi
    names[0]="autoreconf" ; autoreconf -i |& tee rv_build_0.txt ; results[0]="$?" ; postup 0
    names[1]="cmake" ; cmake . |& tee rv_build_1.txt ; results[1]="$?" ; postup 1
    names[2]="configure"  ; ./configure --enable-curldebug CC=$compiler |& tee rv_build_2.txt ; results[2]="$?" ; postup 2
    names[3]="make" ; make -j`nproc` |& tee rv_build_3.txt ; results[3]="$?" ; postup 3
    names[4]="make test" ; make -j`nproc` test |& tee rv_build_4.txt ; results[4]="$?" ; postup 4
}

_test() {
    
    cd curl/tests/
    names[0]="test 1" ; ./runtests.pl 1 |& tee rv_out_0.txt ; results[0]="$?" ; process_config 0
    names[1]="test 2" ; ./runtests.pl 2 |& tee rv_out_1.txt ; results[1]="$?" ; process_config 1
    names[2]="test 3" ; ./runtests.pl 3 |& tee rv_out_2.txt ; results[2]="$?" ; process_config 2

    cd ..
    names[3]="torture tests" ; make -j`nproc` test-torture |& tee rv_out_3.txt ; results[3]="$?" ; process_config 3
}

init
