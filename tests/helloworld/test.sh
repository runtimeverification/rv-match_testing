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
    cd helloworld/ ; echo "$?" |& tee kcc_configure_out.txt ; configure_success="$?"
    #bash $base_dir/timeout.sh -t 5 ls -R / |& tee kcc_make_out.txt ; make_success="$?"
    $compiler helloworld.c |& tee kcc_make_out.txt ; make_success="$?"
}

_test() {
    cd helloworld/
    names[0]="basic run"
    ./a.out |& tee "kcc_out_0.txt" ; results[0]="$?"
}

init
