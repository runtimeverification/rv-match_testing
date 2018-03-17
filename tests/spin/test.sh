#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"
# http://spinroot.com/spin/whatispin.html

_dependencies() {
    sudo apt -y install bison
}

_download() {
    wget http://spinroot.com/spin/Src/spin647.tar.gz
    tar -xvzf spin647.tar.gz
    rm spin647.tar.gz
}

_build() {
    cd Spin/Src6.4.7
    if [[ $compiler == "kcc" ]] ; then
        sed -i -e "s/CC=gcc/CC=$compiler -frecover-all-errors -fissue-report=$json_out/g" makefile ; results[0]="$?"
    else
        sed -i -e "s/CC=gcc/CC=$compiler/g" makefile ; results[0]="$?"
    fi
    process_kcc_config 0

    make ; results[1]="$?" ; process_kcc_config 1
}

_test() {
    cd Spin/Examples/
    mkdir ignore/
    mv abp.pml ignore/
    mv cambridge.pml ignore/
    mv life.pml ignore/
    mv loops.pml ignore/
    mv hajek.pml ignore/
    mv manna_pnueli.pml ignore/
    mv peterson.pml ignore/
    mv priorities.pml ignore/
    mv wordcount.pml ignore/
    # sat worked for kcc but not gcc
    mv sat.pml ignore/
    index=0;
    for f in *.pml; do
        echo "---- testing spin on "$f
        names[index]=${f%".pml"}
        ../Src6.4.7/spin $f |& tee "kcc_out_$index.txt" ; results[index]="$?"
        index=$((index+1))
        process_config $index
        cd Spin/Examples/
        echo "---- finished testing spin on "$f
    done
}

init
