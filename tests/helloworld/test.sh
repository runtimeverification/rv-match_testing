#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/unflattening/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh

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
    cd helloworld/ ; configure_success="$?"
    $compiler helloworld.c ; make_success="$?"
}

_extract() {
    cd helloworld/ && process_kcc_config
    cd helloworld/ && mv kcc_* $log_dir
}

init
