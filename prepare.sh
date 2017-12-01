#!/bin/bash
# This script should be called using the following code at the beginning of each test:
#   [ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/prepare.sh
#   base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh
# That way this can be automatically downloaded if it's missing.
# 
# All functions called in this script that start with an underscore should be
# defined inside the test. After defining these, the test should call `init`.
# They should assume that they are called in test_dir
#
# _download: Download source code and other resources needed here.
# _build: 
# _extract: 

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
    # Step 1: download
    if [ ! -d $download_dir ] || [ -z "$(ls -A $download_dir)" ]; then
        mkdir -p $download_dir
        cd $download_dir
        _download
    fi
    rm -rf $build_dir/*
    cp $download_dir/* $build_dir -r
    
    # Step 2: build
    cd $build_dir && _build
    
    # Step 3: extract
    cd $build_dir && _extract    

    cd $log_dir
    echo "==== kcc configure status reported:"$configure_success
    echo $configure_success > kcc_configure_success.ini
    echo "==== kcc make status reported:"$make_success
    echo $make_success > kcc_make_success.ini
    tar -czvf kcc_compile_out.tar.gz --exclude "kcc_config.txt" kcc_compile_out
}

process_kcc_config() {
    cd $log_dir
    k-bin-to-text kcc_config kcc_config.txt && grep -o "<k>.\{500\}" kcc_config.txt &> kcc_config_k_summary.txt
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
return
}

call_kcc() {
return
}

call_rvpc() {
return
}

mv_kcc_out() {
    mv kcc_* $log_dir
}
