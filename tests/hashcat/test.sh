#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    git submodule update --init
    sudo apt -y install opencl-headers ocl-icd-libopencl1
}

_download() {
    git clone https://github.com/hashcat/hashcat.git
    cd hashcat/
    git checkout f2ce04e9121bf19d82ac1c5d484fdc444d3b78db
}

_build() {
    echo "hi"
    cd hashcat/
    echo "Running special command:"
    kcc -d -c -pipe -std=gnu99 -Iinclude/ -Iinclude/lzma_sdk/ -IOpenCL/ -W -Wall -Wextra -Wfloat-equal -Wundef -Wshadow -Wmissing-declarations -Wmissing-prototypes -Wpointer-arith -Wstrict-prototypes -Waggregate-return -Wswitch-enum -Winit-self -Werror-implicit-function-declaration -Wformat -ftrapv -Wwrite-strings -Wno-cast-align -Wno-cast-qual -Wno-conversion -Wno-padded -Wno-pedantic -Wno-sizeof-pointer-memaccess -O2 -Ideps/OpenCL-Headers/ -DWITH_HWMON src/rp_kernel_on_cpu_optimized.c -o obj/rp_kernel_on_cpu_optimized.NATIVE.STATIC.o
    echo "/Running special command."
    sed -i -e "s/gcc/$compiler/g" ./src/Makefile |& tee kcc_build_0.txt ; results[0]="$?"
    make |& tee kcc_build_1.txt ; results[1]="$?"
}

init
