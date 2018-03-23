#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    :
}

_download() {
    mkdir helloworld/
    cd helloworld/
    touch helloworld.java
    echo "
/* Hello World program */

public class HelloWorld {
    public static void main(String[] args) {
        System.out.println("\"Hello World\"");
    }

}
" > HelloWorld.java
}

_build() {
    [ -d helloworld/ ] |& tee rv_build_0.txt ; results[0]="$?" ; postup 0
    if [ "${results[0]}" == "0" ] ; then cd helloworld/ ; else return ; fi
    bash $base_dir/timeout.sh -t 10 javac HelloWorld.java |& tee rv_build_1.txt ; results[1]="$?" ; postup 1
}

_test() {
    cd helloworld/
    names[0]="basic run"
    java HelloWorld |& tee "rv_out_0.txt" ; results[0]="$?"
}

init
