#!/bin/bash
. prepare.sh $(basename $(dirname $BASH_SOURCE))

git clone https://github.com/FFmpeg/FFmpeg.git
cd FFmpeg
git checkout acf70639fb534a4ae9b1e4c76153f0faa0bda190
./configure --cc=kcc --ld=kcc |& tee kcc_configure_out.txt
make examples |& tee kcc_make_out.txt
kcc -d -I. -I./ -D_ISOC99_SOURCE -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -D_POSIX_C_SOURCE=200112 -D_XOPEN_SOURCE=600 -D__BSD_VISIBLE -D__XSI_VISIBLE -I./compat/atomics/gcc -DHAVE_AV_CONFIG_H -std=c11 -fomit-frame-pointer -pthread -g -Wdeclaration-after-statement -Wall -Wdisabled-optimization -Wpointer-arith -Wredundant-decls -Wwrite-strings -Wtype-limits -Wundef -Wmissing-prototypes -Wno-pointer-to-int-cast -Wstrict-prototypes -Wempty-body -Wno-parentheses -Wno-switch -Wno-format-zero-length -Wno-pointer-sign -Wno-unused-const-variable -Wno-bool-operation -c -o libavdevice/alldevices.o libavdevice/alldevices.c |& tee kcc_out.txt
mv_kcc_out
cd $build_dir
tar -czvf kcc_compile_out.tar.gz kcc_compile_out
