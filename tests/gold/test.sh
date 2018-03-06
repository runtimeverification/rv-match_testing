#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    sudo apt -y install bison flex texinfo
}

_download() {
    git clone git://sourceware.org/git/binutils-gdb.git
    cd binutils-gdb/
    git checkout tags/binutils-2_27
}

_build() {
    # https://github.com/linux-on-ibm-z/docs/wiki/Building-Gold-Linker
    cd binutils-gdb/
    names[0]="configure" ; ./configure CC=$compiler --prefix=/opt/binutils-2.27 --enable-gold |& tee kcc_build_0.txt ; results[0]="$?" ; process_kcc_config 0
    names[1]="make" ; make |& tee kcc_build_1.txt ; results[1]="$?" ; process_kcc_config 1
}

_test() {
    :
}

init
