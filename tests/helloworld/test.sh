#!/bin/bash

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
