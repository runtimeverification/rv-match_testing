#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    ps aux | grep apt
    sudo apt -y install libreadline-dev
    sudo apt -y install ncurses-dev
    sudo apt -y install libncurses5-dev
    sudo apt -y install libncursesw5-dev

}

_download() {
    git clone https://github.com/LuaDist/lua.git
    cd lua/
    git checkout d2e7e7d4d43ff9068b279a617c5b2ca2c2771676
}

_build() {
    cd lua/
    CC=$compiler CFLAGS="-std=gnu11" LD=$compiler LDFLAGS="-lm -ldl" cmake . |& tee kcc_build_0.txt ; results[0]="$?" ; process_kcc_config 0
    results[1]="2"
    if [ "$results[0]" == "0" ] ; then
        CC=$compiler CFLAGS="-std=gnu11" LD=$compiler LDFLAGS="-lm -ldl" make |& tee kcc_build_1.txt ; temp_success="$?"
        if [ "$temp_success" == "0" ] && [ -f lua ] ; then
            results[1]="0"
        fi
    fi
}

init
