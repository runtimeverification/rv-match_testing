#!/bin/bash
currentscript="prepare.sh"
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
# _build: Set make_success and configure_success. "set -o pipefail" should be run before this function is called, otherwise expect false positive results for compilation.
# _extract: Move interesting files like kcc_* to log_dir and call process_kcc_config if applicable
# _test: Set test_success. Same rules as _build for "set -o pipefail".
# _extract_test: Same rules as _extract except for tests instead of build.

exportfile="report"
while getopts ":rs" opt; do
  case ${opt} in
    r ) echo $currentscript" regression option selected."
        exportfile="regression"
      ;;
    s ) echo $currentscript" status option selected."
        echo "Not implemented."
      ;;
    \? ) echo $currentscript" usage: cmd [-r] [-s]"
         echo " -r regression"
         echo " -s status"
      ;;
  esac
done

enforce_common_init_in_test_files() {
    line1='#!/bin/bash'
    line2='[ ! -f prepare.sh ] \&\& wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh'
    line3='base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"'
    echo "Variables:"
    echo $line1
    echo $line2
    echo $line3
    echo "End variables."
    sed -i '1s|.*|'"$line1"'|' $test_file
    sed -i '2s|.*|'"$line2"'|' $test_file
    sed -i '3s|.*|'"$line3"'|' $test_file
}

err(){ >&2 echo "$@"; }

compiler=${1:-kcc}

test_name=$(basename $(pwd))

test_dir=$(pwd)
test_file=$test_dir/test.sh
enforce_common_init_in_test_files
download_dir=$test_dir/download
report_file=$test_dir/$exportfile.xml
rm $report_file ; touch $report_file

process_kcc_config() {
    if cp kcc_config $build_log_dir
    then
        cd $build_log_dir
        k-bin-to-text kcc_config kcc_config.txt && grep -o "<k>.\{500\}" kcc_config.txt &> kcc_config_k_summary.txt && cat kcc_config_k_summary.txt
    else
        echo "prepare.sh did not find a kcc_config in "$(dirname $(pwd))
    fi
    cd $build_dir
}

process_config() {
    if cp config $test_log_dir
    then
        cd $test_log_dir
        #k-bin-to-text config kcc_config.txt && grep -o "<k>.\{500\}" kcc_config.txt &> kcc_config_k_summary.txt && echo kcc_config_k_summary.txt
        grep -o "<k>.\{500\}" config &> kcc_config_k_summary.txt && cat kcc_config_k_summary.txt
        grep -o "<curr-program-loc>.\{500\}" config &> kcc_config_loc_summary.txt && cat kcc_config_loc_summary.txt
    else
        echo "prepare.sh did not find a config in "$(dirname $(pwd))
    fi
    cd $build_dir
}

prep_prepare() {
    report_string=" ===> "$test_name" "$compiler" "

    build_dir=$test_dir/$compiler/build
    mkdir -p $build_dir

    unit_test_dir=$test_dir/$compiler/unit_test
    mkdir -p $unit_test_dir
}

prep_download() {
    if [ ! -d $download_dir ] || [ -z "$(ls -A $download_dir)" ] || [ ! -e $download_dir/download_function_hash ] || [ "$(echo $(sha1sum <<< $(type _download)))" != "$(head -n 1 $download_dir/download_function_hash)" ] ; then
        echo $report_string" downloading. Either this is the initial download or the download hash has changed since the last download."
        if [ ! -d $download_dir ] ; then
            echo "first"
            if [ -z "$(ls -A $download_dir)" ] ; then
                echo "second"
                if [ ! -e $download_dir/download_function_hash ] ; then
                    echo "third"
                    if [ "$(echo $(sha1sum <<< $(type _download)))" != "$(head -n 1 $download_dir/download_function_hash)" ] ; then
                        echo "fourth"
                    fi
                fi
            fi
        fi
        rm -r $download_dir
        mkdir -p $download_dir
        cd $download_dir && _download && cd $download_dir && echo $(sha1sum <<< $(type _download)) > download_function_hash
    else
        echo $report_string" not downloading. Copying from there."
        find $download_dir -maxdepth 2
    fi
}

prep_extract() {
    
    build_log_dir=$test_dir/$compiler/build_log/$(date +%Y-%m-%d.%H:%M:%S)
    mkdir -p $build_log_dir
    ln -sfn $build_log_dir $test_dir/$compiler/build_log/latest
    echo $build_log_dir    
    log_dir=$build_log_dir #until scripts are updated

    # extract build results
    [ ""$(find $build_dir -name "kcc_config") == "" ] ; no_kcc_config_generated_success="$?"
    cd $build_log_dir
    echo $no_kcc_config_generated_success > no_kcc_config_generated_success.ini
    echo $report_string" kcc_config prevention status reported:"$no_kcc_config_generated_success

    cd $build_log_dir
    if [ ! -z ${configure_success+x} ]; then
        echo $configure_success > configure_success.ini
        echo $report_string" configure:"$configure_success
    fi
    if [ ! -z ${make_success+x} ]; then
        echo $make_success > make_success.ini
        echo $report_string"      make:"$make_success
        echo '<testcase classname="'$exportfile'.'${test_name/./"_"}'" name="'$compiler' make success" time="'$time'">' >> $report_file

        if [[ "$make_success" != 0 ]] ; then
            echo '<error message="Failed."> </error>' >> $report_file
        fi
    fi
    cd $build_dir && _extract
    if [ ! -z ${make_success+x} ]; then
        echo '</testcase>' >> $report_file
    fi
}

prep_build() {
    
    # Build hash is dependent on 3 things: {_build() function definition, $compiler --version, download hash}.
    buildhashinfo=$(type _build)$($compiler --version)$(head -n 1 $download_dir/download_function_hash)
    if [ ! -e $build_dir/build_function_hash ] || [ "$(echo $(sha1sum <<< $buildhashinfo))" != "$(head -n 1 $build_dir/build_function_hash)" ] || [ "0" == "0" ] ; then

        # build
        echo $report_string" building. Either build hash changed or this is the first time building."
        safe_rm=$build_dir && [[ ! -z "$safe_rm" ]] && rm -rf $safe_rm/*
        cp $download_dir/* $build_dir -r
        set -o pipefail
        unset configure_success
        unset make_success
        starttime=`date +%s.%N`
        cd $build_dir && _build
        endtime=`date +%s.%N`
        time=`echo "$endtime - $starttime" | bc -l`
        # generate build hash - should be the last function in the build process since it indicates completion
        cd $build_dir && echo $(sha1sum <<< $buildhashinfo) > build_function_hash
        prep_extract
    else
        echo $report_string" not building. Build hash is the same as last build."
    fi 
}

prep_extract_test() {
    test_log_dir=$test_dir/$compiler/test_log/$(date +%Y-%m-%d.%H:%M:%S)
    mkdir -p $test_log_dir
    ln -sfn $test_log_dir $test_dir/$compiler/test_log/latest
    echo $test_log_dir
    log_dir=$test_log_dir #until scripts are updated

    # extract test results
    cd $test_log_dir
    if [ ! -z ${test_success+x} ]; then
        echo $report_string"      test:"$test_success
        echo $test_success > test_success.ini
    fi


    if [[ -v results[@] ]] ; then
        for t in "${!results[@]}"
        do
            echo '<testcase classname="'$exportfile'.'${test_name/./"_"}'" name="'$compiler' '${names[$t]}'">' >> $report_file
            if [[ ${results[$t]} == 0 ]] ; then
                echo $report_string" test: "${names[$t]}" Passed!"
            else
                echo $report_string" test: "${names[$t]}" Failed!"
                echo '<error message="Failed."> </error>' >> $report_file
            fi
            echo '</testcase>' >> $report_file
        done
    fi
    cd $unit_test_dir && _extract_test
}

prep_test() {
    # Test hash is dependent on 3 things: {_test() function definition, $compiler --version, build hash}.
    testhashinfo=$(type _test)$($compiler --version)$(head -n 1 $build_dir/build_function_hash)
    if [ ! -e $unit_test_dir/test_function_hash ] || [ "$(echo $(sha1sum <<< $testhashinfo))" != "$(head -n 1 $unit_test_dir/test_function_hash)" ]  || [ "0" == "0" ] ; then

        # test
        echo $report_string" testing. Either the test hash changed or this is the first unit test run."
        safe_rm=$unit_test_dir && [[ ! -z "$safe_rm" ]] && rm -rf $safe_rm/*
        cp $build_dir/* $unit_test_dir -r
        set -o pipefail
        unset test_success
        cd $unit_test_dir && _test

        # generate test hash - should be the last function in the testing process since it indicates completion
        cd $unit_test_dir && echo $(sha1sum <<< $testhashinfo) > test_function_hash
        prep_extract_test
    else
        echo $report_string" not running unit tests. Testing hash is the same as last test run."
    fi
}

init_helper() {
    prep_prepare
    prep_download
    prep_build
    #prep_test
}

init() {
    if [[ $exportfile != "regression" ]] ; then
        compiler="gcc" && init_helper
    fi
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
