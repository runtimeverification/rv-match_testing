#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    ldd --version
    apt-cache policy libc6
    # See cFE, may fix this, too "configure: error: C compiler cannot create executables": sudo apt install libc6-dev
    sudo apt -y install libxml2-dev
}

_download() {
    git clone https://github.com/php/php-src.git
    cd php-src/
    git checkout edc77d5d00ec3ee3c547e7e08ae4e36fc11deb49
    echo "Force new DL"
}

_build() {
    export echo=echo
    cd php-src/
    names[0]="autoreconf" ; autoreconf -i                         |& tee kcc_build_0.txt ; results[0]="$?" ; postup 0
    names[1]="buildconf"  ; ./buildconf CC=$compiler LD=$compiler |& tee kcc_build_1.txt ; results[1]="$?" ; postup 1
    names[2]="configure"  ; ./configure CC=$compiler LD=$compiler |& tee kcc_build_2.txt ; results[2]="$?" ; postup 2
    names[3]="make"       ; make                                  |& tee kcc_build_3.txt ; results[3]="$?" ; postup 3
}

init
