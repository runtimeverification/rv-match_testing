#!/bin/bash
err(){ >&2 echo "$@"; }

test_name=$(basename $(dirname $(pwd)))

test_dir=$(pwd)
test_file=$test_dir/test.sh
build_dir=$test_dir/build
log_dir=$test_dir/log/$(date +%Y-%m-%d.%H:%M:%S)

mkdir -p $build_dir
mkdir -p $log_dir

ln -sf $log_dir $test_dir/log/latest

cd $build_dir

mv_kcc_out() {
    mv kcc_* $log_dir
}