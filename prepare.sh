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
# _extract: Move interesting files like kcc_* to log_dir and call process_kcc_config if applicable

err(){ >&2 echo "$@"; }

compiler=${1:-kcc}

test_name=$(basename $(dirname $(pwd)))

test_dir=$(pwd)
test_file=$test_dir/test.sh
download_dir=$test_dir/download

process_kcc_config() {
    if mv kcc_config $log_dir
    then
        cd $log_dir
        k-bin-to-text kcc_config kcc_config.txt && grep -o "<k>.\{500\}" kcc_config.txt &> kcc_config_k_summary.txt
    else
        echo "prepare.sh did not find a kcc_config in "$(dirname $(pwd))
    fi
    cd $build_dir
}

init_helper() {
    # Step 0: prepare
    build_dir=$test_dir/$compiler/build
    mkdir -p $build_dir

    log_dir=$test_dir/$compiler/log/$(date +%Y-%m-%d.%H:%M:%S)
    mkdir -p $log_dir
    ln -sfn $log_dir $test_dir/$compiler/log/latest && echo "LATEST"
    echo $log_dir

    unit_test_dir=$test_dir/unit_test

    # Step 1: download
    if [ ! -d $download_dir ] || [ -z "$(ls -A $download_dir)" ]; then
        mkdir -p $download_dir
        cd $download_dir
        _download
    fi
    safe_rm=$build_dir && [[ ! -z "$safe_rm" ]] && rm -rf $safe_rm/*
    cp $download_dir/* $build_dir -r
    
    # Step 2: build
    set -o pipefail
    cd $build_dir && _build
    
    # Step 3: extract
    cd $build_dir && _extract    

    cd $log_dir
    echo "==== $compiler configure status reported:"$configure_success
    echo $configure_success > configure_success.ini
    echo "==== $compiler make status reported:"$make_success
    echo $make_success > make_success.ini
}

init() {
    compiler="gcc" && init_helper
    compiler="kcc" && init_helper
}

# The following functions are currently unused.
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
