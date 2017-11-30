#!/bin/bash
rm -rf helloworld_kcc_test
mkdir helloworld_kcc_test
cd helloworld_kcc_test
STRTDIR=$(pwd)
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
gcc helloworld.c ; gcc_success="$?"
kcc helloworld.c ; make_success="$?"
echo "gcc: "$gcc_success
echo "kcc: "$make_success
cd $STRTDIR
mkdir kcc_compile_out/
cd kcc_compile_out/
echo $gcc_success > gcc_make_success.ini
echo $make_success > kcc_make_success.ini
