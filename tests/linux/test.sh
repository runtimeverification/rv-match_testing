#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh

# TODO: This still needs work.
# I'm not sure how to properly build linux.
git clone https://github.com/torvalds/linux.git
cd linux
git checkout 4fbd8d194f06c8a3fd2af1ce560ddb31f7ec8323
make mrproper CC=kcc LD=kcc |& tee kcc_make_out.txt

