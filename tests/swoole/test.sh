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
    cd swoole-src/
    names[0]="phpize"
    phpize      |& tee kcc_build_0.txt ; results[0]="$?" ; process_kcc_config 0
    ./configure CC=$compiler LD=$compiler |& tee kcc_build_1.txt ; results[1]="$?" ; process_kcc_config 1
    make        |& tee kcc_build_2.txt ; results[2]="$?" ; process_kcc_config 2
    make test   |& tee kcc_build_3.txt ; results[3]="$?" ; process_kcc_config 3
}

_test() {
    cd swoole-src/
    names[0]="make test"
    make test |& tee kcc_out_0.txt ; results[0]="$?"
}

init
