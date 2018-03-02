#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    :
}

_download() {
    if [ -d ../published/ ] && [ ! -d published_copy/ ] ; then
        cp -r ../published/ published_copy/
        cd published_copy/
    fi
}

_build() {
    cd published_copy/ ; echo "$?" |& tee kcc_build_0.txt ; results[0]="$?" ; process_kcc_config 0
    index=1
    for f in *.c; do
        names[index]="build "${f%".c"}
        $compiler -o ${f%".c"} $f |& tee kcc_build_$index.txt ; results[index]="$?" ; process_kcc_config $index
        index=$((index+1))
    done
}

_test() {
    cd published_copy/
    names[0]="kcc -v test"
    kcc -v |& tee "kcc_out_0.txt" ; results[0]="$?"
    index=1
    if [ "$exportfile" == "regression" ] ; then
        mkdir ignore/
        mv *.c ignore/
        mv ignore/floatprintf.c .
        mv ignore/emptystructures.c .
        mv ignore/const.c .
    fi
    for f in *.c; do
        names[index]="run "${f%".c"}
        ./${f%".c"} |& tee kcc_out_$index.txt ; results[index]="$?" ; process_config $index
        index=$((index+1))
    done
}

init
