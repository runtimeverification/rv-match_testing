#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    sudo apt -y install libncursesw5-dev libreadline6-dev
}

_download() {
    git clone https://github.com/jarun/nnn.git
    cd nnn/
    git checkout 7be0726164442a83f47e5a9a0cdf2db343832d23
}

_build() {
    names[0]="make"
    cd nnn/ ; CC=$compiler LD=$compiler make |& tee rv_build_0.txt ; results[0]="$?" ; postup 0
    names[1]="make install"
    CC=$compiler LD=$compiler make install |& tee rv_build_1.txt ; results[1]="$?" ; postup 1
}

_test() {
    :
}

init
