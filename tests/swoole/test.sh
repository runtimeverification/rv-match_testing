#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    sudo apt-get -y install php7.0-dev
}

_download() {
    git clone https://github.com/swoole/swoole-src.git
    cd swoole-src/
    git checkout 5faa17a5a5e7f9912616d08511b704f55b3b7cd7
}

_build() {
    # Note: non-trivial linking
    cd swoole-src/
    names[0]="phpize"    ; phpize                   |& tee rv_build_0.txt ; results[0]="$?" ; postup 0
    names[1]="configure" ; ./configure CC=$compiler |& tee rv_build_1.txt ; results[1]="$?" ; postup 1
    names[2]="make"      ; make                     |& tee rv_build_2.txt ; results[2]="$?" ; postup 2
}

_test() {
    cd swoole-src/
    names[0]="make test"
    make test |& tee rv_out_0.txt ; results[0]="$?" ; process_config 0
}

init
