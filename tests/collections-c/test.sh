#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    sudo apt -y install pkg-config

    start_dep_dir=$(pwd)
    wget https://github.com/cpputest/cpputest/releases/download/v3.8/cpputest-3.8.tar.gz
    tar -xzvf cpputest-3.8.tar.gz
    cd cpputest-3.8/
    autoreconf
    ./configure
    make
    sudo make install
    cd "$start_dep_dir"
    rm -r cpputest-3.8/
    rm cpputest-3.8.tar.gz
}

_download() {
    git clone https://github.com/srdja/Collections-C.git
    cd Collections-C/
    git checkout 6e3c76ef0c6065aa5cfb924099457174a11183c0
}

_build() {
    cd Collections-C/
    CC=$compiler cmake . ; echo "$?" |& tee kcc_configure_out.txt ; configure_success="$?"
    make |& tee kcc_make_out.txt ; make_success="$?"
}

_test() {
    cd Collections-C/test/
    names[0]="array"
    ./array_test |& tee "kcc_out_0.txt" ; results[0]="$?"
    names[1]="deque"
    ./deque_test |& tee "kcc_out_1.txt" ; results[1]="$?"
    names[2]="hashset"
    ./hashset_test |& tee "kcc_out_2.txt" ; results[2]="$?"
    names[3]="hashtable"
    ./hashtable_test |& tee "kcc_out_3.txt" ; results[3]="$?"
    names[4]="list"
    ./list_test |& tee "kcc_out_4.txt" ; results[4]="$?"
    names[5]="pqueue"
    ./pqueue_test |& tee "kcc_out_5.txt" ; results[5]="$?"
    names[6]="queue"
    ./queue_test |& tee "kcc_out_6.txt" ; results[6]="$?"
    names[7]="slist"
    ./slist_test |& tee "kcc_out_7.txt" ; results[7]="$?"
    names[8]="stack"
    ./stack_test |& tee "kcc_out_8.txt" ; results[8]="$?"
    names[9]="treeset"
    ./treeset_test |& tee "kcc_out_9.txt" ; results[9]="$?"
    names[10]="treetable"
    ./treetable_test |& tee "kcc_out_10.txt" ; results[10]="$?"
}

init
