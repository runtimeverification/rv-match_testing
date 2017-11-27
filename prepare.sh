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

test_file=$(pwd)/tests/$test_name/test.sh
build_dir=$(pwd)/tests/$test_name/build
log_dir=$(pwd)/tests/$test_name/log

mkdir -p $build_dir
mkdir -p $log_dir

log_file=$log_dir/$(date +%Y-%m-%d.%H:%M:%S).log

touch $log_file
ln -sf $log_file $log_dir/latest.log

cd $build_dir