#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    sudo apt -y install cmake
    cmake --version
    sudo apt -y install libc6
    sudo apt -y install libc6-dev
    sudo apt -y install libc6-dev-i386
    sudo apt -y install g++-multilib
}

_download() {
    wget "https://sourceforge.net/projects/coreflightexec/files/cFE-6.5.0a-OSS-release.tar.gz"
    tar -xvzf cFE-6.5.0a-OSS-release.tar.gz
    wget "https://sourceforge.net/projects/osal/files/osal-4.2.1a-release.tar.gz"
    tar zxf osal-4.2.1a-release.tar.gz
    cd osal-4.2.1a-release/src/os/
    ln -sf posix posix-ng
    cd ../../../cFE-6.5.0-OSS-release/
    rm -r osal
    ln -s ../osal-4.2.1a-release ./osal
    cp -a cfe/cmake/sample_defs/ .
    rm -r build/
    mkdir build/
    # Refer to the other files for getting rvpc to work
}

_build() {

    ulimit -s 16777216
    # Step 0
    cd cFE-6.5.0-OSS-release/build/
    export SIMULATION=native
    #cmake -DCMAKE_C_COMPILER=gcc -DENABLE_UNIT_TESTS=TRUE --build ../cfe
    #make mission-all
    #CMAKE_C_LINK_EXECUTABLE
    #CMAKE_C_FLAGS
    compilerwithkccflags=$compiler
    if [[ $compiler = "kcc" ]] ; then
        compilerwithkccflags="kcc -frecover-all-errors"
        echo "Using -frecover-all-errors"
    else
        echo "Not using -frecover-all-errors"
    fi
    cmake -DCMAKE_C_COMPILER=$compilerwithkccflags -DENABLE_UNIT_TESTS=TRUE --build ../cfe |& tee kcc_build_0.txt ; results[0]="$?" ; names[0]="cmake" ; process_kcc_config 0

    # Step 1
    make mission-all |& tee kcc_build_1.txt ; results[1]="$?" ; names[1]="make mission-all" ; process_kcc_config 1
    
    # Step 2
    names[2]="unit-tests folder found"
    [ -d native/osal/unit-tests/ ] |& tee kcc_build_2.txt ; results[2]="$?" ; process_kcc_config 2

    # Step 3
    names[3]="make unit-tests" ; results[3]="1"
    if [ "${results[2]}" == "0" ] ; then
        cd native/osal/unit-tests/ && make |& tee kcc_build_3.txt ; results[3]="$?"
    else
        echo "Unit tests folder was not found, so their build fails." > kcc_build_3.txt
    fi
    process_kcc_config 3

}

_test() {
    # tests seem to run indefinitely now   
    #sudo /bin/sh -c "echo 100 > /proc/sys/fs/mqueue/msg_max"
    ulimit -s 16777216
    cd cFE-6.5.0-OSS-release/build/
    tmot=120
    names[0]="timer" ; bash $base_dir/timeout.sh -t $tmot ./native/osal/unit-tests/ostimer-test/osal_timer_UT |& tee kcc_out_0.txt ; results[0]="$?" ; process_config 0
    names[1]="network" ; bash $base_dir/timeout.sh -t $tmot ./native/osal/unit-tests/osnetwork-test/osal_network_UT |& tee kcc_out_1.txt ; results[1]="$?" ; process_config 1
    names[2]="loader" ; bash $base_dir/timeout.sh -t $tmot ./native/osal/unit-tests/osloader-test/osal_loader_UT |& tee kcc_out_2.txt ; results[2]="$?" ; process_config 2
    names[3]="file" ; bash $base_dir/timeout.sh -t $tmot ./native/osal/unit-tests/osfile-test/osal_file_UT |& tee kcc_out_3.txt ; results[3]="$?" ; process_config 3
    names[4]="filesys" ; bash $base_dir/timeout.sh -t $tmot ./native/osal/unit-tests/osfilesys-test/osal_filesys_UT |& tee kcc_out_4.txt ; results[4]="$?" ; process_config 4
    names[5]="core" ; bash $base_dir/timeout.sh -t $tmot ./native/osal/unit-tests/oscore-test/osal_core_UT |& tee kcc_out_5.txt ; results[5]="$?" ; process_config 5
    names[6]="bin-sem-flush" ; bash $base_dir/timeout.sh -t $tmot ./native/osal/tests/bin-sem-flush-test |& tee kcc_out_6.txt ; results[6]="$?" ; process_config 6
    names[7]="bin-sem" ; bash $base_dir/timeout.sh -t $tmot ./native/osal/tests/bin-sem-test |& tee kcc_out_7.txt ; results[7]="$?" ; process_config 7
    names[8]="bin-sem-timeout" ; bash $base_dir/timeout.sh -t $tmot ./native/osal/tests/bin-sem-timeout-test |& tee kcc_out_8.txt ; results[8]="$?" ; process_config 8
    names[9]="count-sem" ; bash $base_dir/timeout.sh -t $tmot ./native/osal/tests/count-sem-test |& tee kcc_out_9.txt ; results[9]="$?" ; process_config 9
    names[10]="file-api" ; bash $base_dir/timeout.sh -t $tmot ./native/osal/tests/file-api-test |& tee kcc_out_10.txt ; results[10]="$?" ; process_config 10
    names[11]="mutex" ; bash $base_dir/timeout.sh -t $tmot ./native/osal/tests/mutex-test |& tee kcc_out_11.txt ; results[11]="$?" ; process_config 11
    names[12]="osal-core" ; bash $base_dir/timeout.sh -t $tmot ./native/osal/tests/osal-core-test |& tee kcc_out_12.txt ; results[12]="$?" ; process_config 12
    names[13]="queue-timeout" ; bash $base_dir/timeout.sh -t $tmot ./native/osal/tests/queue-timeout-test |& tee kcc_out_13.txt ; results[13]="$?" ; process_config 13
    names[14]="symbol-api" ; bash $base_dir/timeout.sh -t $tmot ./native/osal/tests/symbol-api-test |& tee kcc_out_14.txt ; results[14]="$?" ; process_config 14
    names[15]="timer" ; bash $base_dir/timeout.sh -t $tmot ./native/osal/tests/timer-test |& tee kcc_out_15.txt ; results[15]="$?" ; process_config 15
}

init
