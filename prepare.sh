#!/bin/bash
currentscript="prepare.sh"
# This script should be called using the following code at the beginning of each test:
# #!/bin/bash
# [ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
# base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"
#
# That way this can be automatically downloaded if it's missing.
# 
# All functions called in this script that start with an underscore should be
# defined inside the test. After defining these, the test should call `init`.
# They should assume that they are called in test_dir
#
# _download: Download source code and other resources needed here.
# _build: Set make_success and configure_success. "set -o pipefail" should be run before this function is called, otherwise expect false positive results for compilation.
# _extract: Move interesting files like kcc_* to build_log_dir and call process_kcc_config if applicable
# _test: Set test_success. Same rules as _build for "set -o pipefail".
# _extract_test: Same rules as _extract except for tests instead of build.

exportfile="report"
unittesting="1"
gcconly="1"
prepareonly="1"
rvpredict="1"
forcebuild="1"
echo $currentscript" selecting options.."
while getopts ":rsatgpPb" opt; do
  case ${opt} in
    r ) echo $currentscript" regression option selected."
        exportfile="regression"
      ;;
    s ) echo $currentscript" status option selected."
        echo "Not implemented."
      ;;
    a ) echo $currentscript" acceptance option selected."
        exportfile="acceptance"
      ;;
    t ) echo $currentscript" unit test option selected."
        unittesting="0"
      ;;
    g ) echo $currentscript" gcc only option selected."
        gcconly="0"
      ;;
    p ) echo $currentscript" prepare option selected."
        prepareonly="0"
      ;;
    P ) echo $currentscript" rv-predict option selected."
        rvpredict="0"
      ;;
    b ) echo $currentscript" force build option selected."
        forcebuild="0"
      ;;
    \? ) echo $currentscript" usage: cmd [-r] [-s] [-a] [-t] [-g] [-p] [-P] [-b]"
         echo " -r regression"
         echo " -s status"
         echo " -a acceptance"
         echo " -t unit tests"
         echo " -g gcc only"
         echo " -p prepare only"
         echo " -P rv-predict"
         echo " -b force build"
      ;;
  esac
done

enforce_common_init_in_test_files() {
    line1='#!/bin/bash'
    line2='[ ! -f prepare.sh ] \&\& wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh'
    line3='base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"'
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
dependency_dir=$test_dir/dependency
download_dir=$test_dir/download
report_file=$test_dir/$exportfile.xml
rm $report_file ; touch $report_file

prep_prepare() {
    report_string=" ===> "$test_name" "$compiler" "

    build_dir=$test_dir/$compiler/build
    mkdir -p $build_dir

    unit_test_dir=$test_dir/$compiler/unit_test
    mkdir -p $unit_test_dir

    if [ ! -d $dependency_dir ] || [ -z "$(ls -A $dependency_dir)" ] || [ ! -e $dependency_dir/dependency_function_hash ] || [ "$(echo $(sha1sum <<< $(type _dependencies)))" != "$(head -n 1 $dependency_dir/dependency_function_hash)" ] ; then
    echo $report_string" installing dependencies. Hash is new or changed."
    i=0
    if [ fuser /var/lib/dpkg/lock >/dev/null 2>&1 ] ; then
        echo "$report_string: $current_script: Waiting for other software managers to finish..."
    fi
    while fuser /var/lib/dpkg/lock >/dev/null 2>&1 ; do
        sleep 0.5
        ((i=i+1))
    done 
    _dependencies
        rm -f $dependency_dir/dependency_function_hash ; rm -rf $dependency_dir
        mkdir -p $dependency_dir
        cd $dependency_dir && _dependencies && cd $dependency_dir && echo $(sha1sum <<< $(type _dependencies)) > dependency_function_hash
    else
        echo $report_string" not installing dependencies. Hash matches."
    fi
}

prep_download() {
    if [ ! -d $download_dir ] || [ -z "$(ls -A $download_dir)" ] || [ ! -e $download_dir/download_function_hash ] || [ "$(echo $(sha1sum <<< $(type _download)))" != "$(head -n 1 $download_dir/download_function_hash)" ] ; then
        echo $report_string" downloading. Hash is new or changed."
        rm -f $download_dir/download_function_hash ; rm -rf $download_dir
        mkdir -p $download_dir
        cd $download_dir && _download && cd $download_dir && echo $(sha1sum <<< $(type _download)) > download_function_hash
    else
        echo $report_string" not downloading. Hash matches."
    fi
}

increment_process_kcc_config() {
    increment="$index"-"$counter"
    copiedfile=kcc_config_no_$increment
    cp kcc_config $build_log_dir/$copiedfile ; rm kcc_config
    location=$(pwd) ; cd $build_log_dir
    if [ -e $copiedfile ] ; then
        echo $'\n\n'"Found a kcc_config number $increment:" >> kcc_config_k_summary$increment.txt
        echo "Location: $location" >> kcc_config_k_summary$increment.txt
        k-bin-to-text $copiedfile $copiedfile.txt &>> kcc_config_k_summary$increment.txt
        if [ $? -eq 0 ] ; then
            grep -o "<k>.\{0,500\}" $copiedfile.txt &> kcc_config_k_term$increment.txt
            grep -o "<curr-program-loc>.\{0,500\}" $copiedfile.txt &> kcc_config_loc_term$increment.txt
        else
            echo "k-bin-to-text command failed with above error." >> kcc_config_k_summary$increment.txt
        fi
        echo "$location" &> kcc_config_dir$increment.ini
    else
        echo "Error: report this bug in rv-match_testing. This message should have been unreachable."
        echo "===== is there a $copiedfile here?" ; pwd ; ls ; echo "=====" ; exit 1
    fi
    echo "$counter" > $index.ini
    let "counter += 1"
    dumpstring="Translation failed (kcc_config dumped). To repeat, run this command in directory "
    more=`grep -A1 "$dumpstring" "$returnspot/kcc_build_$index.txt"`
    morefolder=`printf "${more#$dumpstring}" | head -n 1`
    coloncharacter=":"
    morefolder=${morefolder%$coloncharacter}
    morecommand=`printf "$more" | tail -n 1`
    locstr="$(basename $location)"
    [ "$locstr" == "$morefolder" ] ; echo "$?"
    if [ "$locstr" == "$morefolder" ] ; then
        echo $'\n\n'"As requested in the log seen below, running command: {"$'\n'"$morecommand"$'\n'"} in the \"$locstr\" folder to get more information: {"$'\n' &>> kcc_config_k_summary$increment.txt
        cd $location ; eval "$morecommand" &>> $build_log_dir/kcc_config_k_summary$increment.txt ; rm kcc_config ; cd $build_log_dir
        echo "}" &>> kcc_config_k_summary$increment.txt
    fi
}

process_kcc_config() { # Called by _build in test.sh which is called by prep_build() here
    returnspot=$(pwd)
    re='^[0-9]+$'
    if ! [[ $1 =~ $re ]] ; then
        echo "rv-match_testing error in prepare.sh: the argument to \"process_kcc_config\" should be an integer, not \"$1\"" |& tee -a kcc_config_k_summary$increment.txt
        index="0"
    else
        index="$1"
    fi
    cd $build_dir
    counter=0
    while IFS= read -r -d $'\0' line; do
        return_dir=$(pwd)
        cd $(dirname $line) && increment_process_kcc_config
        cd $return_dir
    done < <(find . -type f -iname "kcc_config" -print0)
    now=`date +%s.%N`
    build_time[$1]=`echo "$now - $intervalstarttime" | bc -l`
    intervalstarttime=$now
    cd $returnspot
}

process_config() { # Called by _test in test.sh which is called by prep_test() here
    returnspot=$(pwd)
    re='^[0-9]+$'
    if ! [[ $1 =~ $re ]] ; then
        echo "rv-match_testing error in prepare.sh: the argument to \"process_config\" should be an integer, not \"$1\"" |& tee -a kcc_config_k_summary$increment.txt
        increment="0"
    else
        increment="$1"
    fi
    if [ -f config ] ; then
        copiedfile=config_$increment
        cp config $test_log_dir/$copiedfile
        cd $test_log_dir
        grep -o "<k>.\{0,500\}" $copiedfile &> "config_k_summary$increment.txt"
        grep -o "<curr-program-loc>.\{0,500\}" $copiedfile &> "config_loc_term$increment.txt"
    else
        echo "No 'config' found for unit-test: \"${names[$increment]}\"." &>> kcc_config_k_summary$increment.txt
    fi
    now=`date +%s.%N`
    run_time[$1]=`echo "$now - $intervalstarttime" | bc -l`
    intervalstarttime=$now
    cd $returnspot
}

prep_extract() {

    # Extract build results
    [ "$(find $build_dir -name "kcc_config")" == "" ] ; no_kcc_config_generated_success="$?"
    cd $build_log_dir
    echo $no_kcc_config_generated_success > no_kcc_config_generated_success.ini
    echo $report_string" kcc_config prevention status reported:"$no_kcc_config_generated_success

    cd $build_log_dir
    if [ ! -z ${configure_success+x} ]; then
        echo $configure_success > configure_success.ini
        echo $report_string" configure:"$configure_success
    fi
    if [ ! -z ${make_success+x} ]; then
        echo "$make_success" > make_success.ini
        echo "$time" > make_time.ini
        echo $report_string"      make:"$make_success
    fi
    i=${#results[@]}
    process_kcc_config "$i"
    if [ ! "$counter" == "0" ] ; then
        names[$i]="GENERATED-TEST[kcc_config]"
        results[$i]="1"
        echo "Fix test.sh to call process_kcc_config after tests." > $build_log_dir/kcc_build_$i.txt
    fi
    if [ "$i" == "0" ] ; then
        names[$i]="GENERATED-TEST[feedback]"
        results[$i]="1"
        echo "Fix test.sh to report some sort of build feedback." > $build_log_dir/kcc_build_$i.txt
    fi
    # Extract log details: copy the non-kcc_config log files.
    find $build_dir -name "kcc_*" -not -name "kcc_config" -exec cp {} $build_log_dir \;
    # New: Generate XML just like in extract_test()
    cd $build_log_dir
    if [[ -v results[@] ]] ; then
        for t in "${!results[@]}"
        do
            echo '<testcase classname="'$exportfile'.'${test_name/./"_"}'" name="'$compiler' '${names[$t]}'" time="'${build_time[$t]}'">' >> $report_file
            if [[ ${results[$t]} == 0 ]] ; then
                echo $report_string" build step: "${names[$t]}" Passed!"
            else
                echo $report_string" build step: "${names[$t]}" Failed!"
                echo '<error message="Failed.">' >> $report_file
                print=$'\nBuild step '"$t"$', '"\"${names[$t]}\""$': {\n'
                print=$print$(type _build)$'\n'
                if [[ -e "$t.ini" ]] ; then
                    for s in `seq 0 "$(head -n 1 $t.ini)"`
                    do
                        i="$t-$s"
                        if [[ -e "kcc_config_k_summary$i.txt" ]] ; then
                            print=$print$'\n\nkcc_config info: '$(cat kcc_config_k_summary$i.txt)
                        fi
                        if [[ -e "kcc_config_k_term$i.txt" ]] ; then
                            print=$print$'\n\n<k> term: \n'$(cat kcc_config_k_term$i.txt)
                        fi
                        if [[ -e "kcc_config_loc_term$i.txt" ]] ; then
                            print=$print$'\n\nProgram location term: \n'$(cat kcc_config_loc_term$i.txt)
                        fi
                    done
                fi
                if [[ -e "kcc_build_$t.txt" ]] ; then
                        print=$print$'\n\nBuild step log tail: \n'$(tail -20 kcc_build_$t.txt)
                fi
                print=$print$'\n}'
                printf "<![CDATA[%s]]>" "$print" >> $report_file
                echo '</error>' >> $report_file
            fi
            echo '</testcase>' >> $report_file
        done
    fi
}

prep_build() {
    build_log_dir=$test_dir/$compiler/build_log/$(date +%Y-%m-%d.%H:%M:%S)
    mkdir -p $build_log_dir
    ln -sfn $build_log_dir $test_dir/$compiler/build_log/latest
    echo $build_log_dir    

    # Build hash is dependent on 3 things: {_build() function definition, $compiler --version, download hash}.
    buildhashinfo=$(type _build)$($compiler --version)$(head -n 1 $download_dir/download_function_hash)$(head -n 1 $dependency_dir/dependency_function_hash)
    echo "`kcc --version`" | grep "Build number" ; kcc_is_versioned="$?"
    if [ ! -e $build_dir/build_function_hash ] || [ "$(echo $(sha1sum <<< $buildhashinfo))" != "$(head -n 1 $build_dir/build_function_hash)" ] || [ ! "$kcc_is_versioned" == "0" ] || [ "$forcebuild" == "0" ] ; then

        # build
        echo $report_string" building. Either first build, hash changed, \"kcc --version\" does not provide a build number, or the 'force build' (-b) option was used."
        type _build
        rm $build_dir/build_function_hash ; safe_rm=$build_dir && [[ ! -z "$safe_rm" ]] && rm -rf $safe_rm/*
        cp $download_dir/* $build_dir -r
        set -o pipefail
        unset results
        unset names
        starttime=`date +%s.%N`
        kcc -profile x86_64-linux-gcc-glibc
        export OCAMLRUNPARAM=b
        intervalstarttime="$starttime"
        names[0]="configure success"
        names[1]="make success"
        cd $build_dir && _build
        endtime=`date +%s.%N`
        time=`echo "$endtime - $starttime" | bc -l`
        # generate build hash - should be the last function in the build process since it indicates completion
        cd $build_dir && echo $(sha1sum <<< $buildhashinfo) > build_function_hash
        prep_extract
    else
        echo $report_string" not building. Same build hash exists."
    fi 
}

prep_extract_test() {
    # Save test successes into .ini
    cd $test_log_dir
    echo "Supposed to be in log directory..."
    pwd
    echo "/supposed"
    if [ ! -z ${test_success+x} ]; then
        echo $report_string"      test:"$test_success
        echo $test_success > test_success.ini
    fi

    # Copy output logs (kcc_out_#.txt)
    cd $unit_test_dir
    find . -name "kcc_*" -not -name "kcc_config" -exec cp {} $test_log_dir \;
    cd $test_log_dir

    # Generate xml
    if [[ -v results[@] ]] ; then
        for t in "${!results[@]}"
        do
            echo '<testcase classname="'$exportfile'.'${test_name/./"_"}'" name="'$compiler' '${names[$t]}'" time="'${run_time[$t]}'">' >> $report_file
            if [[ ${results[$t]} == 0 ]] ; then
                echo $report_string" test: "${names[$t]}" Passed!"
            else
                echo $report_string" test: "${names[$t]}" Failed!"
                echo '<error message="Failed.">' >> $report_file
                print=$'\nTest '"$t"$', '"\"${names[$t]}\""$': {'
                if [[ -e "config_k_summary$t.txt" ]] ; then
                    print=$print$'\n<k> term: \n'$(cat config_k_summary$t.txt)
                fi
                if [[ -e "config_loc_term$t.txt" ]] ; then
                    print=$print$'\nProgram location term: \n'$(cat config_loc_term$t.txt)
                fi
                if [[ -e "kcc_out_$t.txt" ]] ; then
                    print=$print$'\nTest log tail: \n'$(tail -20 kcc_out_$t.txt)
                fi
                print=$print$'\n}'
                printf "<![CDATA[%s]]>" "$print" >> $report_file
                echo '</error>' >> $report_file
            fi
            echo '</testcase>' >> $report_file
        done
    fi
}

prep_test() {
    unset results
    unset names
    # Need to prep log directory here instead of extract test since test.sh calls process_config which depends on the log directory existing
    test_log_dir=$test_dir/$compiler/test_log/$(date +%Y-%m-%d.%H:%M:%S)
    mkdir -p $test_log_dir
    ln -sfn $test_log_dir $test_dir/$compiler/test_log/latest
    echo $test_log_dir

    # Test hash is dependent on 3 things: {_test() function definition, $compiler --version, build hash}.
    testhashinfo=$(type _test)$($compiler --version)$(head -n 1 $build_dir/build_function_hash)
    if [ ! -e $unit_test_dir/test_function_hash ] || [ "$(echo $(sha1sum <<< $testhashinfo))" != "$(head -n 1 $unit_test_dir/test_function_hash)" ]  || [ "0" == "0" ] ; then

        # test
        echo $report_string" testing. Either the test hash changed or this is the first unit test run."
        safe_rm=$unit_test_dir && [[ ! -z "$safe_rm" ]] && rm -rf $safe_rm/*
        cp $build_dir/* $unit_test_dir -r
        set -o pipefail
        unset test_success
        starttime=`date +%s.%N`
        intervalstarttime="$starttime"
        cd $unit_test_dir && increment="0" && _test
        echo "rvpredict variable: [$rvpredict]"
        export rvpredict

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
    if [ ! "$prepareonly" == "0" ] ; then
        prep_build
        if [ "$unittesting" == "0" ] ; then
            echo $currentscript": Unit testing."
            prep_test
        else
            echo $currentscript": Not unit testing."
        fi
    fi
}

init() {
    echo '<testcase classname="'$exportfile'.'${test_name/./"_"}'" name="GENERATED-TEST[timeout]">' >> $report_file
    echo '<error message="Failed."></error>' >> $report_file
    echo '</testcase>' >> $report_file
    echo "pwd:"
    pwd
    echo "base_dir:"
    echo "$base_dir"
    if [ ! -f $base_dir/timeout.sh ] ; then
        echo "$currentscript: downloading timeout.sh."
        wget -P $base_dir https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/timeout.sh
    fi
    if [ ! "$exportfile" == "regression" ] ; then
        compiler="gcc" && init_helper
    fi
    if [ ! "$gcconly" == "0" ] && [ ! "$rvpredict" == "0" ] ; then
        compiler="kcc" && init_helper
    fi
    if [ ! "$gcconly" == "0" ] && [ "$rvpredict" == "0" ] ; then
        compiler="rvpc" && init_helper
    fi
    sed -i '1,3d' $report_file
}
