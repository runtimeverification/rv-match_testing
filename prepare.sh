#!/bin/bash
# This script should be called using the following code at the beginning of each test:
#   [ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/prepare.sh
#   base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh
# That way this can be automatically downloaded if it's missing.
# 
# All functions called in this script that start with an underscore should be
# defined inside the test. After defining these, the test should call `init`.
#
# _download: Download source code and other resources needed here.

err(){ >&2 echo "$@"; }

compiler=${1:-kcc}

test_name=$(basename $(dirname $(pwd)))

test_dir=$(pwd)
test_file=$test_dir/test.sh
download_dir=$test_dir/download
build_dir=$test_dir/build
log_dir=$test_dir/log/$(date +%Y-%m-%d.%H:%M:%S)
unit_test_dir=$test_dir/unit_test

mkdir -p $build_dir
mkdir -p $log_dir

ln -sf $log_dir $test_dir/log/latest

init() {
    if [ ! -d $download_dir ] || [ -z "$(ls -A $download_dir)" ]; then
        mkdir -p $download_dir
        cd $download_dir
        _download
    fi
    rm -rf $build_dir/*
    cp $download_dir/* $build_dir -r
    cd $build_dir
}

call_compiler() {
    case "$compiler" in
        gcc)
            call_gcc "$@"
            ;;
        kcc)
            call_kcc "$@"
            ;;
        rvpc)
            call_rvpc "$@"
            ;;
        *)
            err "Unknown compiler: $compiler; Valid compilers are: gcc, kcc, rvpc"
            exit 1
    esac
}

call_gcc() {

}

call_kcc() {
    
}

call_rvpc() {
    
}

mv_kcc_out() {
    mv kcc_* $log_dir
}
