#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    sudo apt -y install libreadline-dev
    sudo apt -y install libc-ares-dev
    sudo apt -y install texinfo
}

_download() {
    wget http://git.savannah.gnu.org/cgit/quagga.git/snapshot/quagga-1.2.4.tar.gz
    tar -xzf quagga-1.2.4.tar.gz 
    rm quagga-1.2.4.tar.gz 
    #git clone https://github.com/Quagga/quagga.git
    #cd quagga/
    #git checkout 88d6516676cbcefb6ecdc1828cf59ba3a6e5fe7b
}

_build() {
    # Note: non-trivial linking
    cd quagga-1.2.4/
    names[0]="bootstrap" ; bash bootstrap.sh |& tee rv_build_0.txt ; results[0]="$?" ; postup 0
    names[1]="configure" ; ./configure CC=$compiler |& tee rv_build_1.txt ; results[1]="$?" ; postup 1
    names[2]="make"      ; make              |& tee rv_build_2.txt ; results[2]="$?" ; postup 2
}

_test() {
    :
}

init
