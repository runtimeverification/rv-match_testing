#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    sudo apt -y install libelf-dev
}

_download() {
    git clone https://github.com/torvalds/linux.git
    cd linux/
    git checkout 0adb32858b0bddf4ada5f364a84ed60b196dbcda # Tag v4.16
    #git checkout 4fbd8d194f06c8a3fd2af1ce560ddb31f7ec8323
}

_build() {
    cd linux/
    names[0]="make mrproper" ; make -j`nproc` mrproper CC=$compiler LD=$compiler |& tee rv_build_0.txt ; results[0]="$?" ; postup 0
    names[1]="make defconfig" ; make -j`nproc` defconfig CC=$compiler LD=$compiler |& tee rv_build_1.txt ; results[1]="$?" ; postup 1
    names[2]="make" ; make -j`nproc` CC=$compiler LD=$compiler |& tee rv_build_2.txt ; results[2]="$?" ; postup 2
}

init
