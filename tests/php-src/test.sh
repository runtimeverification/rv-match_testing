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
    cd php-src/
    autoscan
    aclocal
    autoheader
    autoreconf
    ./buildconf CC=$compiler LD=$compiler
    #sudo apt install libxml2-dev
    ./configure CC=$compiler LD=$compiler |& tee kcc_build_0.txt ; results[0]="$?" ; process_kcc_config 0
    echo "PHP-SRC DEBUG"
    cat config.log
    make |& tee kcc_build_1.txt ; results[1]="$?" ; process_kcc_config 1
}

init
