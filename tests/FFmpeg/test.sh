#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh

git clone https://github.com/FFmpeg/FFmpeg.git
build_dir=base_dir/FFmpeg/
cd $build_dir
git checkout acf70639fb534a4ae9b1e4c76153f0faa0bda190
set -o pipefail
./configure --cc=kcc --ld=kcc |& tee kcc_configure_out.txt ; configure_success="$?"
make examples |& tee kcc_make_out.txt ; make_success="$?"
kcc -d -I. -I./ -D_ISOC99_SOURCE -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -D_POSIX_C_SOURCE=200112 -D_XOPEN_SOURCE=600 -D__BSD_VISIBLE -D__XSI_VISIBLE -I./compat/atomics/gcc -DHAVE_AV_CONFIG_H -std=c11 -fomit-frame-pointer -pthread -g -Wdeclaration-after-statement -Wall -Wdisabled-optimization -Wpointer-arith -Wredundant-decls -Wwrite-strings -Wtype-limits -Wundef -Wmissing-prototypes -Wno-pointer-to-int-cast -Wstrict-prototypes -Wempty-body -Wno-parentheses -Wno-switch -Wno-format-zero-length -Wno-pointer-sign -Wno-unused-const-variable -Wno-bool-operation -c -o libavdevice/alldevices.o libavdevice/alldevices.c |& tee kcc_out.txt
mv_kcc_out
cd $log_dir
k-bin-to-text kcc_config kcc_config.txt && grep -o "<k>.\{500\}" kcc_config.txt &> kcc_config_k_summary.txt
echo "==== kcc configure status reported:"$configure_success
echo $configure_success > kcc_configure_success.ini
echo "==== kcc make status reported:"$make_success
echo $make_success > kcc_make_success.ini
cd $build_dir
tar -czvf kcc_compile_out.tar.gz --exclude "kcc_config.txt" kcc_compile_out
