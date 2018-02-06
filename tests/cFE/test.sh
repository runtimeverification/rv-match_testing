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
    # sudo apt install libc6-dev-i386
    # Refer to the other files for getting rvpc to work
}

_build() {
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
    cmake -DCMAKE_C_COMPILER=$compilerwithkccflags -DENABLE_UNIT_TESTS=TRUE --build ../cfe |& tee kcc_configure_out.txt ; configure_success="$?"
    make mission-all |& tee kcc_make_out.txt ; make_success="$?"
    if [ $make_success -eq 0 ] ; then
        cd native/osal/unit-tests/ && make |& tee kcc_make_out.txt ; make_success="$?"
    fi
}

_test() {
    # tests seem to run indefinitely now   

    #sudo /bin/sh -c "echo 100 > /proc/sys/fs/mqueue/msg_max"
    cd cFE-6.5.0-OSS-release/build/
    
    names[0]="timer" ; ./native/osal/unit-tests/ostimer-test/osal_timer_UT ; results[0]="$?"
    names[1]="network" ; ./native/osal/unit-tests/osnetwork-test/osal_network_UT ; results[1]="$?"
    names[2]="loader" ; ./native/osal/unit-tests/osloader-test/osal_loader_UT ; results[2]="$?"
    names[3]="file" ; ./native/osal/unit-tests/osfile-test/osal_file_UT ; results[3]="$?"
    names[4]="filesys" ; ./native/osal/unit-tests/osfilesys-test/osal_filesys_UT ; results[4]="$?"
    names[5]="core" ; ./native/osal/unit-tests/oscore-test/osal_core_UT ; results[5]="$?"

    names[6]="bin-sem-flush" ; ./native/osal/tests/bin-sem-flush-test ; results[6]="$?"
    names[7]="bin-sem" ; ./native/osal/tests/bin-sem-test ; results[7]="$?"
    names[8]="bin-sem-timeout" ; ./native/osal/tests/bin-sem-timeout-test ; results[8]="$?"
    names[9]="count-sem" ; ./native/osal/tests/count-sem-test ; results[9]="$?"
    names[10]="file-api" ; ./native/osal/tests/file-api-test ; results[10]="$?"
    names[11]="mutex" ; ./native/osal/tests/mutex-test ; results[11]="$?"
    names[12]="osal-core" ; ./native/osal/tests/osal-core-test ; results[12]="$?"
    names[13]="queue-timeout" ; ./native/osal/tests/queue-timeout-test ; results[13]="$?"
    names[14]="symbol-api" ; ./native/osal/tests/symbol-api-test ; results[14]="$?"
    names[15]="timer" ; ./native/osal/tests/timer-test ; results[15]="$?"
}

init
