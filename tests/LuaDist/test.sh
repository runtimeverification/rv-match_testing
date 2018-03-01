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
    if [ "${results[0]}" == "0" ] ; then
        CC=$compiler CFLAGS="-std=gnu11" LD=$compiler LDFLAGS="-lm -ldl" make |& tee kcc_build_1.txt ; temp_success="$?"
        if [ "$temp_success" == "0" ] && [ -f lua ] ; then
            results[1]="0"
        fi
    fi
    process_kcc_config 1
}

_test() {
    cd lua/
    names[0]="bisect"       ; lua bisect.lua    |& tee kcc_out_0.txt ; results[0]="$?" ; process_config
    names[1]="cf"           ; lua cf.lua        |& tee kcc_out_1.txt ; results[1]="$?" ; process_config
    names[2]="factorial"    ; lua factorial.lua |& tee kcc_out_2.txt ; results[2]="$?" ; process_config
    names[3]="fib"          ; lua fib.lua       |& tee kcc_out_3.txt ; results[3]="$?" ; process_config
    names[4]="fibfor"       ; lua fibfor.lua    |& tee kcc_out_4.txt ; results[4]="$?" ; process_config
    names[5]="hello"        ; lua hello.lua     |& tee kcc_out_5.txt ; results[5]="$?" ; process_config
    names[6]="life"         ; lua life.lua      |& tee kcc_out_6.txt ; results[6]="$?" ; process_config
    names[7]="luac"         ; lua luac.lua hello.lua |& tee kcc_out_7.txt ; results[7]="$?" ; process_config
    names[8]="printf"       ; lua printf.lua    |& tee kcc_out_8.txt ; results[8]="$?" ; process_config
    names[9]="sort"         ; lua sort.lua      |& tee kcc_out_9.txt ; results[9]="$?" ; process_config
    names[10]="trace-calls" ; lua trace-calls.lua |& tee kcc_out_10.txt ; results[10]="$?" ; process_config
}

init
