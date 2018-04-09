#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    sudo apt -y install autoconf2.64
}

_download() {
    #git clone git://sourceware.org/git/binutils-gdb.git
    #https://www.gnu.org/software/binutils/
    #https://github.com/gittup/binutils
    wget https://ftp.gnu.org/gnu/binutils/binutils-2.30.tar.gz
    tar -xzf binutils-2.30.tar.gz
    rm -f binutils-2.30.tar.gz
}

_build() {
    cd binutils-2.30/
    #http://trac.clfs.org/ticket/926
    #sed -i -e 's/@colophon/@@colophon/' \
    #   -e 's/doc@cygnus.com/doc@@cygnus.com/' bfd/doc/bfd.texinfo |& tee rv_build_0.txt ; results[0]="$?" ; postup 0
    names[0]="autoreconf" ; autoreconf2.64                        |& tee rv_build_0.txt ; results[0]="$?" ; postup 0
    names[1]="configure"  ; ./configure CC=$compiler LD=$compiler |& tee rv_build_1.txt ; results[1]="$?" ; postup 1
    names[2]="make"       ; make -j 8   CC=$compiler LD=$compiler |& tee rv_build_2.txt ; results[2]="$?" ; postup 2
}

_test() {
    :
}

init
