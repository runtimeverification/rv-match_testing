#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    :
}

_download() {
    mkdir helloworld/
    cd helloworld/
    touch helloworld.c
    echo "
/* Hello World program */

#include<stdio.h>

int main()
{
    printf(\"Hello World\");

}
" > helloworld.c
}

_build() {
    [ -d helloworld/ ] |& tee kcc_build_0.txt ; results[0]="$?" ; postup 0
    if [ "${results[0]}" == "0" ] ; then cd helloworld/ ; else return ; fi
    bash $base_dir/timeout.sh -t 10 $compiler helloworld.c |& tee kcc_build_1.txt ; results[1]="$?" ; postup 1
}

_test() {
    cd helloworld/
    names[0]="basic run"
    ./a.out |& tee "kcc_out_0.txt" ; results[0]="$?"
}

init
