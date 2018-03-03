#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    sudo apt -y install openssl
    sudo apt -y install libssl-dev
}

_download() {
    git clone https://source.isc.org/git/bind9.git
    cd bind9/
    git checkout 63270d33f1103f6193aebd6c205b78064b4cdfe5
}

_build() {
    ulimit -s 16777216
    cd bind9/
    bind9dir=$(pwd)
    names[0]="outer configure step"
    ./configure --prefix=$HOME/bind9 --host=x86_64-linux-gnu --build=x86_64-pc-linux-gnu --with-randomdev=/dev/random --with-ecdsa=yes --with-gost=yes --with-eddsa=no --with-atf=$HOME/rv/bind9/unit/atf BUILD_CC=gcc CC=rvpc CXX=rvpc++ |& tee kcc_make_0.txt ; results[0]="$?" ; process_kcc_config 0
    names[1]="found unit/atf-src/" ; [ -d unit/atf-src/ ] ; results[1]="$?" ; process_kcc_config 1
    cd unit/atf-src/
    names[2]="inner configure step"
    ./configure --prefix=$HOME/rv/bind9/unit/atf --enable-tools --disable-shared |& tee kcc_make_2.txt ; results[2]="$?" ; process_kcc_config 2
    names[3]="inner make" ; make |& tee kcc_make_3.txt ; results[3]="$?" ; process_kcc_config 3
    names[4]="inner make install" ; make install |& tee kcc_make_4.txt ; results[4]="$?" ; process_kcc_config 4
    cd $bind9dir
    names[5]="outer make" ; make |& tee kcc_make_5.txt ; results[5]="$?" ; process_kcc_config 5
}

_test() {
    cd bind9/
    names[0]="make unit"
    make unit |& tee kcc_out_0.txt ; results[0]="$?" ; process_config 0
}

init
