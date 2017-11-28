#!/bin/bash
err(){ >&2 echo "$@"; }

test_name=$1

if [ -z "$test_name" ]; then
    err "Missing test name."
    exit
elif [[ ! "$test_name" =~ ^[A-Za-z0-9_\-\.]+$ ]]; then
    err "Bad test name: $test_name"
    err "Only alphanumeric characters, underscores, hyphens, and dots are allowed."
    exit
fi

test_dir=$(pwd)/tests/$test_name
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