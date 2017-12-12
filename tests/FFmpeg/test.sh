#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh

_download() {
    git clone https://github.com/FFmpeg/FFmpeg.git
    cd FFmpeg/
    git checkout acf70639fb534a4ae9b1e4c76153f0faa0bda190
}

_build() {
    cd FFmpeg/
    set -o pipefail
    ./configure --cc=$compiler --ld=$compiler |& tee kcc_configure_out.txt ; configure_success="$?"
    make examples |& tee kcc_make_out.txt ; make_success="$?"
    $compiler -d -I. -I./ -D_ISOC99_SOURCE -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -D_POSIX_C_SOURCE=200112 -D_XOPEN_SOURCE=600 -D__BSD_VISIBLE -D__XSI_VISIBLE -I./compat/atomics/gcc -DHAVE_AV_CONFIG_H -std=c11 -fomit-frame-pointer -pthread -g -Wdeclaration-after-statement -Wall -Wdisabled-optimization -Wpointer-arith -Wredundant-decls -Wwrite-strings -Wtype-limits -Wundef -Wmissing-prototypes -Wno-pointer-to-int-cast -Wstrict-prototypes -Wempty-body -Wno-parentheses -Wno-switch -Wno-format-zero-length -Wno-pointer-sign -Wno-unused-const-variable -Wno-bool-operation -c -o libavdevice/alldevices.o libavdevice/alldevices.c |& tee kcc_out.txt
}

_extract() {
    cd FFmpeg/ && process_kcc_config
    cd FFmpeg/ && cp kcc_* $log_dir
}

init
